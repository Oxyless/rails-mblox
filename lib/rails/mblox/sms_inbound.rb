require 'nokogiri'

module Rails
  module Mblox
    class SmsInbound
      def self.binary_to_utf_8(data)
        two_bytes_group = data.scan(/.{2}/)
        result = ""

        two_bytes_group.each do |group|
          result << group.hex.to_i.chr(Encoding::ISO_8859_1)
        end

        result.encode('utf-8')
      end

      def self.from_xml(response_as_xml)
        response_as_xml = URI.decode(response_as_xml).gsub('XMLDATA=', '').gsub('+', ' ')
        doc = Nokogiri::XML(response_as_xml)

        originating_number = doc.xpath("//OriginatingNumber").text
        data = doc.xpath("//Data").text
        msg_reference = doc.xpath("//MsgReference").text
        format = doc.xpath("//Response/@Format").text

        if data and format == 'Binary'
          data = self.binary_to_utf_8(data)
        end

        return originating_number, data, msg_reference
      end
    end
  end
end