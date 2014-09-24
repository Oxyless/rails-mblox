require "rails/mblox"
require 'pry'

describe Rails::Mblox do
  describe 'configuration' do
    it 'confiure Mblox with default values' do
      Rails::Mblox.config.version.should == "3.5"
      Rails::Mblox.config.outbound_urls.should == [ "http://xml9.mblox.com:8180/send", "http://xml10.mblox.com:8180/send" ]
      Rails::Mblox.config.sequence_number.should == "1"
      Rails::Mblox.config.message_type.should == "SMS"
      Rails::Mblox.config.format.should == "UTF8"
      Rails::Mblox.config.message_type.should == "SMS"
      Rails::Mblox.config.profile.should == "-1"
      Rails::Mblox.config.sender_type.should == "Numeric"
      Rails::Mblox.config.content_type.should == "-1"
    end

    it 'configure Mblox class' do
      Rails::Mblox.configure do |config|
        config.version = "2.5"
        config.outbound_urls = [ "http://xml1.mblox.com:8180/send", "http://xml2.mblox.com:8180/send" ]
        config.partner_name = "partner_name"
        config.partner_password = "partner_password"
        config.username = "username"
        config.subscription_name = "subscription_name"
        config.sequence_number = "2"
        config.message_type = "FlashSMS"
        config.format = "Text"
        config.profile_id = "12345"
        config.sender_type = "Numeric"
        config.sender_id = "+33641973183"
        config.expire_date = "00000005"
        config.operator = "operator"
        config.tariff = "0"
        config.tags = { :tag_name => :tag_value }
        config.content_type = "-1"
        config.service_id = "service_id"
      end

      Rails::Mblox.config.version.should == "2.5"
      Rails::Mblox.config.outbound_urls.should == [ "http://xml1.mblox.com:8180/send", "http://xml2.mblox.com:8180/send" ]
      Rails::Mblox.config.partner_name.should == "partner_name"
      Rails::Mblox.config.partner_password.should == "partner_password"
      Rails::Mblox.config.sequence_number.should == "2"
      Rails::Mblox.config.message_type.should == "FlashSMS"
      Rails::Mblox.config.format.should == "Text"
      Rails::Mblox.config.profile_id.should == "12345"
      Rails::Mblox.config.sender_type.should == "Numeric"
      Rails::Mblox.config.sender_id.should == "+33641973183"
      Rails::Mblox.config.expire_date.should == "00000005"
      Rails::Mblox.config.operator.should == "operator"
      Rails::Mblox.config.tariff.should == "0"
      Rails::Mblox.config.content_type.should == "-1"
      Rails::Mblox.config.service_id.should == "service_id"

      Rails::Mblox.reset_config
    end

    it 'configure Mblox object' do
      mblox = Rails::Mblox::Mblox.new do |config|
        config.version = "4.5"
        config.outbound_url = "http://xml2.mblox.com:8180/send"
        config.partner_name = "another partner_name"
        config.partner_password = "another partner_password"
        config.username = "username"
        config.subscription_name = "subscription_name"
        config.sequence_number = "2"
        config.message_type = "FlashSMS"
        config.format = "Text"
        config.profile_id = "12345"
        config.sender_type = "Numeric"
        config.sender_id = "+33641973183"
        config.expire_date = "00000005"
        config.operator = "operator"
        config.tariff = "0"
        config.tags = { :tag_name => :tag_value }
        config.content_type = "-1"
        config.service_id = "service_id"
      end

      mblox.config.version.should == "4.5"
      mblox.config.outbound_urls.should == [ "http://xml2.mblox.com:8180/send" ]
      mblox.config.partner_name.should == "another partner_name"
      mblox.config.partner_password.should == "another partner_password"
      mblox.config.sequence_number.should == "2"
      mblox.config.message_type.should == "FlashSMS"
      mblox.config.format.should == "Text"
      mblox.config.profile_id.should == "12345"
      mblox.config.sender_type.should == "Numeric"
      mblox.config.sender_id.should == "+33641973183"
      mblox.config.expire_date.should == "00000005"
      mblox.config.operator.should == "operator"
      mblox.config.tariff.should == "0"
      mblox.config.content_type.should == "-1"
      mblox.config.service_id.should == "service_id"

      Rails::Mblox.reset_config
    end
  end

  describe 'sms' do
    before(:all) do
      @mblox = Rails::Mblox::Mblox.new do |config|
        config.partner_name = MBLOX_CONFIG[:partner_name] rescue 'p_name'
        config.partner_password = MBLOX_CONFIG[:partner_password] rescue 'p_pass'
        config.profile_id = MBLOX_CONFIG[:profile_id] rescue 'profile'
        config.username = MBLOX_CONFIG[:username] rescue 'username'
      end
    end

    it 'creates a sms' do
      sms = Rails::Mblox::Sms.new(1, (MBLOX_CONFIG[:phone_number] rescue '+33641973183'), "Hello world", @mblox.config)

      sms_xml = sms.to_xml
      sms_xml.should ==
          <<-eos
<?xml version="1.0"?>
<NotificationRequest Version="3.5">
  <NotificationHeader>
    <PartnerName>#{sms.config.partner_name}</PartnerName>
    <PartnerPassword>#{sms.config.partner_password}</PartnerPassword>
    <Username>#{sms.config.username}</Username>
  </NotificationHeader>
  <NotificationList BatchID="#{sms.batch_id}">
    <Notification SequenceNumber="1" MessageType="SMS" Format="UTF8">
      <Message><![CDATA[#{sms.message}]]></Message>
      <Profile>#{sms.config.profile_id}</Profile>
      <Subscriber>
        <SubscriberNumber>#{sms.phone}</SubscriberNumber>
      </Subscriber>
      <ContentType>-1</ContentType>
    </Notification>
  </NotificationList>
</NotificationRequest>
eos
    end

    if defined? MBLOX_CONFIG
      it 'sends a sms' do
        sms = Rails::Mblox::Sms.new(1, MBLOX_CONFIG[:phone_number], "Hello world") do |config|
          config.partner_name = MBLOX_CONFIG[:partner_name]
          config.partner_password = MBLOX_CONFIG[:partner_password]
          config.profile_id = MBLOX_CONFIG[:profile_id]
        end
        code, message = sms.send

        message.should == "Ok"
        code.should == 0
      end

      it 'sends a sms with wrong password' do
        sms = Rails::Mblox::Sms.new(1, MBLOX_CONFIG[:phone_number], "Hello world") do |config|
          config.partner_password == "iamaclown"
        end

        code, message = sms.send

        message.should == "Wrong password"
        code.should == 3
      end
    end
  end
end