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

      def multiparts?
        case @config.format
          when "Text"
            @message.size > 160
          when "Binary"
            @message.size > 140
          when "Unicode"
            @message.size > 70
          else
            @message.size > 160
        end
      end

      def chunck_size
        case @config.format
          when "Text"
            153
          when "Binary"
            134
          when "Unicode"
            67
          else
            153
        end
      end

      def udh_multipart(current_piece, number_of_piece, reference_number)
        return "" if number_of_piece == 1

        header_size = ":05"
        iei = ":00"
        sub_header_size = ":03"
        reference_number = ":#{reference_number}"
        number_of_piece = ":#{number_of_piece.to_s.rjust(2, '0')}"
        current_piece = ":#{current_piece.to_s.rjust(2, '0')}"

        return "#{header_size}#{iei}#{sub_header_size}#{reference_number}#{number_of_piece}#{current_piece}"
      end


      def to_xml
        messages = [ @message ]
        xml_requests = []

        if self.multiparts?
          raise ArgumentError, "#{@message} too long and multipart disabled" unless @config.multipart_enabled?

          messages = @message.scan(/.{1,#{self.chunck_size}}/)
        end

        messages.each_with_index do |message, index|
          notification = { :SequenceNumber => @config.sequence_number, :MessageType => @config.message_type }
          notification[:Format] = @config.format if @config.format

          builder = Nokogiri::XML::Builder.new({ :encoding => "ISO-8859-1" }) do |xml|
            xml.NotificationRequest({ :Version => @config.version}) {
              xml.NotificationHeader {
                xml.PartnerName(@config.partner_name)
                xml.PartnerPassword(@config.partner_password)
                xml.Username(@config.username) if @config.username
                xml.SubscriptionName(@config.subscription_name) if @config.subscription_name
              }

              xml.NotificationList({ :BatchID => @batch_id }) {
                xml.Notification(notification) {
                  xml.Message {
                    xml.cdata(message)
                  }
                  xml.Profile(@config.profile_id) if @config.profile_id
                  xml.Udh("Udh") if @config.format == "Binary"
                  xml.Udh(self.udh_multipart(index + 1, messages.size, @config.reference_number)) if self.multiparts?
                  xml.SenderID(@config.sender_id, { :Type => @config.sender_type }) if @config.sender_id
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

          xml_requests <<  builder.to_xml
        end

        return (self.multiparts? ? xml_requests : xml_requests.first)
      end

      def send
        sms_xml = self.to_xml
        outbound_server = @config.outbound_urls.sample

        case sms_xml
          when String
            return  Rails::Mblox::SmsResponse.from_hash(self.class.post(outbound_server, { :body => sms_xml, :headers => {'Content-type' => 'text/xml'} }))
          when Array
            code = log = nil

            sms_xml.each do |xml|
              code, log = Rails::Mblox::SmsResponse.from_hash(self.class.post(outbound_server, { :body => xml, :headers => {'Content-type' => 'text/xml'} }))
              return code, log if code != 0
            end

            return code, log
          else
            return nil, nil
        end
      end
    end
  end
end