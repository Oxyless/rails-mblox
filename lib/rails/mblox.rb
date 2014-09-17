require "rails/mblox/version"
require "rails/mblox/api"

require 'nokogiri'
require 'httparty'

module Rails
  module Mblox
    class Mblox
      include Rails::Mblox::Api
      include HTTParty

      # debug_output $stdout
      #
      def initialize(partner_name, partner_password, options = { })
        opts = {
          :mblox_send_servers => [ "http://xml9.mblox.com:8180/send", "http://xml10.mblox.com:8180/send" ],
          :username => nil,
          :subscription_name => nil,
          :debug => false
        }.merge(options)

        @partner_name = partner_name
        @partner_password = partner_password

        @subscription_name = opts[:subscription_name]
        @username = opts[:username]
        @mblox_send_servers = opts[:mblox_send_servers]
        @debug = opts[:debug]
      end

      # Send a Sms via MBlox
      #
      def send(batch_id, to, message, options = {})
        http_request = self.outbound_sms_request(batch_id, to, message, options)
        http_response = nil
        http_errors = {}

        @mblox_send_servers.each do |mblox_send_server|
            http_response = self.class.post(mblox_send_server, { :body => http_request, :headers => {'Content-type' => 'text/xml'} }) rescue next
            http_errors[mblox_send_server] = { :code => http_response.code, :text => http_response.message } and next if http_response.code != 200
            break
        end

        return http_errors if http_response.code != 200

        puts http_response
        sms_response = self.outbound_sms_response(http_response)

        if @debug
          return sms_response, http_request, http_response.body
        else
          return sms_response
        end
      end

      # getters

      def mblox_send_servers
        return @mblox_send_servers
      end

      def username
        return @username
      end

      def subscription_name
        return @subscription_name
      end

      def debug
        return @debug
      end

      def partner_name
        return @partner_name
      end

      def partner_password
        return @partner_password
      end
    end
  end
end