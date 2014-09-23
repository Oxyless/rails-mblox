require 'nokogiri'

module Rails
  module Mblox
    class SmsInbound
      def self.from_xml(response_as_xml)
        response_as_xml = response_as_xml.gsub('XMLDATA=', '')
        doc = Nokogiri::XML(response_as_xml)

        originating_number = doc.xpath("//OriginatingNumber").text
        data = doc.xpath("//Data").text

        return originating_number, data
      end
    end
  end
end