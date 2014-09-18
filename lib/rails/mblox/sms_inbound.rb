require 'nokogiri'

module Rails
  module Mblox
    class SmsInbound
      def self.parse(response)
        result = response["ResponseService"]
        header = result["Header"]

        response_list = result["ResponseList"]
        response = response_list["Response"]

        originating_number = response["OriginatingNumber"]
        data = response["Data"]

        return originating_number, data
      end
    end
  end
end