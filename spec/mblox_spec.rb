require "rails/mblox"

describe Rails::Mblox do
  before(:each) do
    @mblox = Rails::Mblox::Mblox.new("Username", "Password")
    @mblox2 = Rails::Mblox::Mblox.new("Username", "Password", {
        :mblox_send_servers => [ "http://xml9.mblox.com:8180/send2" ],
        :username => "Login",
        :subscription_name => "SLogin",
        :profile_id => "pid",
        :debug => true,

    })
  end

  it 'test contructor' do
    @mblox2.mblox_send_servers[0].should == "http://xml9.mblox.com:8180/send2"
    @mblox2.username.should == "Login"
    @mblox2.subscription_name.should == "SLogin"
    @mblox2.debug.should == true
    @mblox2.profile_id.should == "pid"

  end

  it 'create outbound_sms_request' do
    request = @mblox.outbound_sms_request(42, "+33601020304", "Hello world")

    request.to_s.should ==
        <<-eos
<?xml version="1.0"?>
<NotificationRequest Version="3.5">
  <NotificationHeader>
    <PartnerName>Username</PartnerName>
    <PartnerPassword>Password</PartnerPassword>
  </NotificationHeader>
  <NotificationList BatchID="42">
    <Notification SequenceNumber="1" MessageType="SMS" Format="Unicode">
      <Message>Hello world</Message>
      <Profile>-1</Profile>
      <Subscriber>
        <SubscriberNumber>0033601020304</SubscriberNumber>
      </Subscriber>
      <ContentType>-1</ContentType>
    </Notification>
  </NotificationList>
</NotificationRequest>
    eos
  end

  it 'create outbound_sms_request complexe' do
    request = @mblox.outbound_sms_request(42, "+33601020304", "Hello world", {
        :version => "3.6", # api version
        :sequence_number => "2", # should be 1 (other value for multi sms on one request, but bot stable)
        :message_type => "FlashSMS", # SMS or FlashSMS
        :format => "Binary", # Text (default)  Binary Unicode Imode
        :profile => 12345, # mblox profile used
        :sender_type => "Shortcode", # Numeric Shortcode or Alpha
        :sender_id => 42, # sender value ("from")
        :expire_date => "00000005", # value between 5 minutes and 12 hours
        :operator => "Matrix", # only on short codes to send SMS to North America or Latin America
        :tariff => "South", # only on short codes to send SMS to North America or Latin America
        :tags => { :tag1 => "value" }, # multi-purpose elements used to carry any parameters that are required for a specific mBlox product
        :content_type => "1", # should be -1
        :service_id => "54321", # only used if you are using short codes to send SMS to the USA
        :username => "uname",
        :partner_name => "pname",
        :partner_password => "ppass",
        :subscription_name => "sname"
    })

    request.to_s.should ==
        <<-eos
<?xml version="1.0"?>
<NotificationRequest Version="3.6">
  <NotificationHeader>
    <PartnerName>pname</PartnerName>
    <PartnerPassword>ppass</PartnerPassword>
    <Username>uname</Username>
    <SubscriptionName>sname</SubscriptionName>
  </NotificationHeader>
  <NotificationList BatchID="42">
    <Notification SequenceNumber="2" MessageType="FlashSMS" Format="Binary">
      <Message>Hello world</Message>
      <Profile>12345</Profile>
      <Udh>Udh</Udh>
      <SenderID Type="Shortcode"/>
      <ExpireDate>00000005</ExpireDate>
      <Operator>Matrix</Operator>
      <Operator>South</Operator>
      <Subscriber>
        <SubscriberNumber>0033601020304</SubscriberNumber>
      </Subscriber>
      <Tags>
        <Tag Name="tag1">value</Tag>
      </Tags>
      <ContentType>1</ContentType>
      <Operator>54321</Operator>
    </Notification>
  </NotificationList>
</NotificationRequest>
    eos
  end

  it 'create outbound_sms_request with UserName and SubscriptionName setted' do
    @mblox2.outbound_sms_request(42, "+33601020304", "Hello world").should ==
      <<-eos
<?xml version="1.0"?>
<NotificationRequest Version="3.5">
  <NotificationHeader>
    <PartnerName>Username</PartnerName>
    <PartnerPassword>Password</PartnerPassword>
    <Username>Login</Username>
    <SubscriptionName>SLogin</SubscriptionName>
  </NotificationHeader>
  <NotificationList BatchID="42">
    <Notification SequenceNumber="1" MessageType="SMS" Format="Unicode">
      <Message>Hello world</Message>
      <Profile>pid</Profile>
      <Subscriber>
        <SubscriberNumber>0033601020304</SubscriberNumber>
      </Subscriber>
      <ContentType>-1</ContentType>
    </Notification>
  </NotificationList>
</NotificationRequest>
  eos
  end

  it 'parse outbound_sms_response complexe' do
    http_response = {"NotificationRequestResult"=>{"NotificationResultHeader"=>{"PartnerName"=>"Wizville", "PartnerRef"=>nil, "RequestResultCode"=>"0", "RequestResultText"=>"OK"}, "NotificationResultList"=>{"NotificationResult"=>{"NotificationResultCode"=>"0", "NotificationResultText"=>"OK", "SubscriberResult"=>{"SubscriberNumber"=>"33641973183", "SubscriberResultCode"=>"0", "SubscriberResultText"=>"OK", "Retry"=>"0", "Operator"=>"0"}, "SequenceNumber"=>"1"}}, "Version"=>"3.5"}}

    response = @mblox.outbound_sms_response(http_response)
    response.to_s.should == "{:mblox=>{:code=>0, :text=>\"OK\"}, :sms=>{:code=>\"0\", :text=>\"OK\"}}"
  end


  it 'parse outbound_sms_response fail' do
    http_response = {"NotificationRequestResult"=>{"NotificationResultHeader"=>{"PartnerName"=>"Wizville", "PartnerRef"=>nil, "RequestResultCode"=>"9", "RequestResultText"=>"Some error"}, "Version"=>"3.5"}}

    response = @mblox.outbound_sms_response(http_response)
    response.to_s.should == "{:mblox=>{:code=>9, :text=>\"Some error\"}}"
  end
end