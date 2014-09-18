require 'httparty'
require 'nokogiri'

module Rails
  module Mblox
    class Sms
      include HTTParty

      attr_accessor :batch_id, :message, :config, :phone

      def configure()
        yield self.config
      end

      def initialize(batch_id, phone, message, config = Rails::Mblox.config.dup)
        @batch_id = batch_id
        @message = message
        @phone = phone.gsub('+', '00')
        @config = config

        yield config if block_given?
      end

      def phone=(new_phone)
        @phone = new_phone.gsub('+', '00')
      end

      def to_xml
        builder = Nokogiri::XML::Builder.new do |xml|
          xml.NotificationRequest({ :Version => @config.version}) {
            xml.NotificationHeader {
              xml.PartnerName(@config.partner_name)
              xml.PartnerPassword(@config.partner_password)
              xml.Username(@config.username) if @config.username
              xml.SubscriptionName(@config.subscription_name) if @config.subscription_name
            }

            xml.NotificationList({ :BatchID => @batch_id }) {
              xml.Notification({ :SequenceNumber => @config.sequence_number, :MessageType => @config.message_type, :Format => @config.format }) {
                xml.Message(@message)
                xml.Profile(@config.profile_id) if @config.profile_id
                xml.Udh("Udh") if @config.format == "Binary"
                xml.SenderID("", { :Type => @config.sender_type }) if @config.sender_id
                xml.ExpireDate(@config.expire_date) if @config.expire_date
                xml.Operator(@config.operator) if @config.operator
                xml.Operator(@config.tariff) if @config.tariff

                xml.Subscriber {
                  xml.SubscriberNumber(@phone)
                }

                unless @config.tags.empty?
                  xml.Tags {
                    @config.tags.each do |tag_name, tag_value|
                      xml.Tag(tag_value, { :Name => tag_name })
                    end
                  }
                end

                xml.ContentType(@config.content_type)
                xml.Operator(@config.service_id) if @config.service_id
              }
            }
          }
        end

        return builder.to_xml
      end

      def send
        sms_xml = self.to_xml

        http_response = self.class.post(@config.outbound_urls.sample, { :body => sms_xml, :headers => {'Content-type' => 'text/xml'} })

        return Rails::Mblox::SmsResponse.parse(http_response)
      end
    end
  end
end