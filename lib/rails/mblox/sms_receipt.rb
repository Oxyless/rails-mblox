require 'nokogiri'

module Rails
  module Mblox
    class SmsReceipt
      def self.from_xml(response)
        result = response["NotificationService"]
        header = result["Header"]

        notification_list = result["NotificationList"]
        notification = notification_list["Notification"]
        subscriber = notification["Subscriber"]
        batch_id = notification["BatchID"]

        subscriber_status = subscriber["Status"]

        return batch_id, subscriber_status
      end
    end
  end
end