# Rails::Mblox

Implementation of Mblox Api for Rails

## Installation

    gem 'rails-mblox', :git => 'https://github.com/Oxyless/rails-mblox.git'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install rails-mblox

## Usage

MBLOX = Rails::Mblox::Mblox.new("MbloxUsername", "MbloxPassword")
MBLOX.send("UniqueId", "33641973183", "Hello world")
=> {:mblox=>{:code=>0, :text=>"OK"}, :sms=>{:code=>"0", :text=>"OK"}}

options: {
    :version => "3.5", # api version
    :sequence_number => "1", # should be 1 (other value for multi sms on one request, but bot stable)
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
