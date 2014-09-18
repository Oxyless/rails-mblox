require 'nokogiri'

module Rails
  module Mblox
    class SmsResponse
      def self.parse(response)
        result = response["NotificationRequestResult"]
        header = result["NotificationResultHeader"]

        header_result_code = header["RequestResultCode"].to_i
        header_result_text = header["RequestResultText"]

        return header_result_code, header_result_text if header_result_code != 0

        notification_result = result["NotificationResultList"]["NotificationResult"]
        notification_result_code = notification_result["NotificationResultCode"].to_i
        notification_result_text = notification_result["NotificationResultText"]

        return notification_result_code, notification_result_text if notification_result_code != 0

        subscriber_result = notification_result["SubscriberResult"]
        subscriber_result_code = subscriber_result["SubscriberResultCode"].to_i
        subscriber_result_text = subscriber_result["SubscriberResultText"]

        return subscriber_result_code, subscriber_result_text if subscriber_result_code != 0

        return 0, "Ok"
      end
    end
  end
end