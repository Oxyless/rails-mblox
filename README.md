# Rails::Mblox

Implementation of Mblox Api for Rails

## Installation

    gem 'rails-mblox', :git => 'https://github.com/Oxyless/rails-mblox.git'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install rails-mblox

## Usage

    MBLOX = Rails::Mblox::Mblox.new("MbloxUsername", "MbloxPassword") # 3th parameter is an optional hash mblox_constructor_options

    mblox_constructor_options = {
      :mblox_send_servers => [ "http://xml9.mblox.com:8180/send", "http://xml10.mblox.com:8180/send" ],
      :username => nil, # This is optional and an alphanumeric string. This element is setup by mBlox in case you want delivery receipts sent to a specific callback URL that is different from the default one on the account.
      :subscription_name => nil, # This is optional and an alphanumeric string. This element is currently not used by mBlox. However, you may use it to identify MT messages grouped under a single SubscriptionName. For example, this may be useful when searching XML documents in log files.
      :debug => false # if true MBLOX.send will return additional http_request, http_response
    }



    MBLOX.send("UniqueId", "33641973183", "Hello world") # 4th parameter is an optional hash mblox_send_options
    => {:mblox=>{:code=>0, :text=>"OK"}, :sms=>{:code=>"0", :text=>"OK"}}

    mblox_send_options: {
        :version => "3.5", # api version
        :sequence_number => "1", # should be 1 (other value for multi sms on one request, but not stable)
        :message_type => "SMS", # SMS or FlashSMS
        :format => "Unicode", # Text (default)  Binary Unicode Imode
        :profile => -1, # mblox profile used
        :sender_type => "Numeric", # Numeric Shortcode or Alpha
        :sender_id => nil, # sender value ("from")
        :expire_date => nil, # value between 5 minutes and 12 hours
        :operator => nil, # only on short codes to send SMS to North America or Latin America
        :tariff => nil, # only on short codes to send SMS to North America or Latin America
        :tags => {}, # multi-purpose elements used to carry any parameters that are required for a specific mBlox product
        :content_type => "-1", # should be -1
        :service_id => nil # only used if you are using short codes to send SMS to the USA
    }

## Contributing

1. Fork it ( http://github.com/<my-github-username>/rails-mblox/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
