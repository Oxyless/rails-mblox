require 'nokogiri'

module Rails
  module Mblox
    class SmsReceipt
      def self.from_xml(response_as_xml)
        response_as_xml = URI.decode(response_as_xml).gsub('XMLDATA=', '').gsub('+', ' ')
        doc = Nokogiri::XML(response_as_xml)

        subscriber_status = doc.xpath("//Status").text
        batch_id = doc.xpath("//Notification/@BatchID").text
        subscriber_number = doc.xpath("//SubscriberNumber").text

        return batch_id, subscriber_number, subscriber_status
      end
    end
  end
end