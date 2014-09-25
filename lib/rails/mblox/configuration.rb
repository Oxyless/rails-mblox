module Rails
  module Mblox
    class << self
      attr_accessor :configuration

      def reset_config
        @config = Configuration.new
      end

      def config
        @config ||= Configuration.new
      end

      def configure
        yield self.config
      end
    end

    class Configuration
      attr_accessor   :version,
                      :outbound_url,
                      :outbound_urls,
                      :partner_name,
                      :partner_password,
                      :username,
                      :subscription_name,
                      :sequence_number,
                      :message_type,
                      :format,
                      :profile_id,
                      :sender_type,
                      :sender_id,
                      :expire_date,
                      :operator,
                      :tariff,
                      :tags,
                      :content_type,
                      :service_id

      attr_writer     :outbound_url

      def version
        @version || "3.5"
      end

      def outbound_url=(url)
        @outbound_urls = [ url ]
      end

      def outbound_urls
        @outbound_urls || [ "http://xml9.mblox.com:8180/send", "http://xml10.mblox.com:8180/send" ]
      end

      def sequence_number
        @sequence_number || "1"
      end

      def message_type
        @message_type || "SMS"
      end

      def format
        @format || "Unicode"
      end

      def profile_id
        @profile_id || "-1"
      end

      def sender_type
        @sender_type || "Numeric"
      end

      def content_type
        @content_type || "-1"
      end

      def tags
        @tags || {}
      end
    end
  end
end