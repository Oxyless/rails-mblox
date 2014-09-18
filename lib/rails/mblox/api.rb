module Rails
  module Mblox
    module Api
      # Forge sms resquest
      #
      def outbound_sms_request(batch_id, to, message, options = {})
        opts = {
            :partner_name => @partner_name, # Mblox username (set by constructor)
            :partner_password => @partner_password, # Mblox password (set by constructor)
            :username => @username, # Optional username (can be set by constructor)
            :subscription_name => @subscription_name, # Optional subscription_name (can be set by constructor)
            :version => "3.5", # api version
            :sequence_number => "1", # should be 1 (other value for multi sms on one request, but not stable)
            :message_type => "SMS", # SMS or FlashSMS
            :format => "Unicode", # Text (default)  Binary Unicode Imode
            :profile => (@profile_id || -1), # mblox profile used (can be set by constructor)
            :sender_type => "Numeric", # Numeric Shortcode or Alpha
            :sender_id => nil, # sender value ("from")
            :expire_date => nil, # value between 5 minutes and 12 hours
            :operator => nil, # only on short codes to send SMS to North America or Latin America
            :tariff => nil, # only on short codes to send SMS to North America or Latin America
            :tags => {}, # multi-purpose elements used to carry any parameters that are required for a specific mBlox product
            :content_type => "-1", # should be -1
            :service_id => nil # only used if you are using short codes to send SMS to the USA
        }.merge(options)

        to.gsub!("+", "00") # mblox doesn't handle '+33...' format
        builder = Nokogiri::XML::Builder.new do |xml|
          xml.NotificationRequest({ :Version => opts[:version]}) {
            xml.NotificationHeader {
              xml.PartnerName(opts[:partner_name])
              xml.PartnerPassword(opts[:partner_password])
              xml.Username(opts[:username]) if opts[:username]
              xml.SubscriptionName(opts[:subscription_name]) if opts[:subscription_name]
            }

            xml.NotificationList({ :BatchID => batch_id }) {
              xml.Notification({ :SequenceNumber => opts[:sequence_number], :MessageType => opts[:message_type], :Format => opts[:format] }) {
                xml.Message(message)
                xml.Profile(opts[:profile]) if opts[:profile]
                xml.Udh("Udh") if opts[:format] == "Binary"
                xml.SenderID("", { :Type => opts[:sender_type] }) if opts[:sender_id]
                xml.ExpireDate(opts[:expire_date]) if opts[:expire_date]
                xml.Operator(opts[:operator]) if opts[:operator]
                xml.Operator(opts[:tariff]) if opts[:tariff]

                xml.Subscriber {
                  xml.SubscriberNumber(to)
                }

                unless opts[:tags].empty?
                  xml.Tags {
                    opts[:tags].each do |tag_name, tag_value|
                      xml.Tag(tag_value, { :Name => tag_name })
                    end
                  }
                end

                xml.ContentType(opts[:content_type])
                xml.Operator(opts[:service_id]) if opts[:service_id]
              }
            }
          }
        end

        return builder.to_xml
      end

      # Extract sms response
      #
      def outbound_sms_response(sms_response)
        response = {}

        header = sms_response['NotificationRequestResult']['NotificationResultHeader']
        mblox_response_code = header['RequestResultCode'].to_i
        mblox_response_text = header['RequestResultText']

        response[:mblox] = { :code => mblox_response_code, :text => mblox_response_text }

        notification_result = sms_response['NotificationRequestResult']['NotificationResultList'].first[1] rescue nil

        if notification_result
          notification_result_code = notification_result['NotificationResultCode']
          notification_result_text = notification_result['NotificationResultText']

          response[:sms] = { :code => notification_result_code, :text => notification_result_text }
        end

        return response
      end
    end
  end
end