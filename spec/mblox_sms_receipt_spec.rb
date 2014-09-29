require "rails/mblox"
require 'pry'

describe Rails::Mblox::SmsReceipt do
  it 'parse receipt datas from doc' do
    datas =
        <<-eos
<NotificationService Version="2.3">
<Header>
<Partner>AccountName</Partner>
    <Password>Password</Password>
<ServiceID>1</ServiceID>
</Header>
<NotificationList>
<Notification BatchID="42" SequenceNumber="1">
<Subscriber>
<SubscriberNumber>0102030405</SubscriberNumber>
            <Status>acked</Status>
<TimeStamp>YYYYMMDDHHmm</TimeStamp>
            <MsgReference>xxxxxxxxxxxx</MsgReference>
<Reason>3</Reason>
        </Subscriber>
</Notification>
</NotificationList>
</NotificationService>
    eos

    batch_id, subscriber_number, subscriber_status, msg_reference = Rails::Mblox::SmsReceipt.from_xml(datas)
    batch_id.should == "42"
    subscriber_status.should == "acked"
    subscriber_number.should == "0102030405"
    msg_reference.should == "xxxxxxxxxxxx"
  end

  it 'parse real receipt datas' do
    datas =
    <<-eos
  XMLDATA=<?xml version="1.0" encoding="ISO-8859-1"?>
  <NotificationService Version="2.3">
      <Header>
      <Partner>Wizville</Partner>
	<Password>z5D3PVp4</Password>
  <ServiceID>1</ServiceID>
</Header>
  <NotificationList>
  <Notification BatchID="6" SequenceNumber="1">
      <Subscriber>
      <SubscriberNumber>33641973183</SubscriberNumber>
			<Status>Delivered</Status>
  <TimeStamp>201409231413</TimeStamp>
			<MsgReference>20991272511411481597322</MsgReference>
  <Reason>4</Reason>
		</Subscriber>
  </Notification>
</NotificationList>
  </NotificationService>
    eos

    batch_id, subscriber_number, subscriber_status, msg_reference = Rails::Mblox::SmsReceipt.from_xml(datas)
    batch_id.should == "6"
    subscriber_status.should == "Delivered"
    subscriber_number.should == "33641973183"
    msg_reference.should == "20991272511411481597322"
  end

end


