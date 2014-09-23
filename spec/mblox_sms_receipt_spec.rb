require "rails/mblox"
require 'pry'

describe Rails::Mblox::SmsReceipt do
  it 'parse inbound datas' do
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

    batch_id, subscriber_status = Rails::Mblox::SmsReceipt.from_xml(datas)
    batch_id.should == "42"
    subscriber_status.should == "acked"
  end
end


