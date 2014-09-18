require "rails/mblox/version"
require "rails/mblox/configuration"
require "rails/mblox/sms"
require "rails/mblox/sms_response"
require "rails/mblox/sms_receipt"
require "rails/mblox/sms_inbound"

module Rails
  module Mblox
    class Mblox
      attr_accessor :config

      def config
        @config ||= Rails::Mblox.config.dup
      end

      def configure()
        yield self.config
      end

      def initialize()
        yield self.config if block_given?
      end
    end
  end
end