# Rails::Mblox

Implementation of Mblox Api for Rails

## Installation

    gem 'rails-mblox', :git => 'https://github.com/Oxyless/rails-mblox.git'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install rails-mblox

## Usage

    Rails::Mblox.configure do |config|
        config.partner_name = "partner_name"
        config.partner_password = "partner_password"
        config.profile_id = "12345"
    end

    mblox_sms = Rails::Mblox::Sms.new(42, "+33641973183", "Hello world")
    code, message = mblox_sms.send

    originating_number, data = Rails::Mblox::SmsInbound.from_xml(xml_request)
    batch_id, subscriber_number, subscriber_status = Rails::Mblox::SmsReceipt.from_xml(xml_request)

## Contributing

1. Fork it ( http://github.com/<my-github-username>/rails-mblox/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
