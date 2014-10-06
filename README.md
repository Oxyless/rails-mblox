# Rails::Mblox

Implementation of Mblox Api for Rails

## Installation

    gem 'rails-mblox', :git => 'https://github.com/Oxyless/rails-mblox.git'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install rails-mblox

## Usage

Example:

    Rails::Mblox.configure do |config|
        config.partner_name = "partner_name"
        config.partner_password = "partner_password"
        config.profile_id = "12345"
    end

    mblox_sms = Rails::Mblox::Sms.new(42, "+33641973183", "Hello world")
    code, message = mblox_sms.send

    originating_number, data, msg_reference = Rails::Mblox::SmsInbound.from_xml(xml_request)
    batch_id, subscriber_number, subscriber_status, msg_reference = Rails::Mblox::SmsReceipt.from_xml(xml_request)

List of characteres supported with default format (Text - max 160):

    ñ ò ö ø ù ü á ä å æ è é ì Ñ Ö Ø Ü ß Ä Å Æ Ç É ¿ i £ ¤ ¥ §
    p q r s t u v w x y z a b c d e f g h i j k l m n o
    P Q R S T U V W X Y Z @ A B C D E F G H I J K L M N O
    0 1 2 3 4 5 6 7 8 9 : ; < = > ?
    SP ! " # $ % & ' ( ) * + , - . / LF CR

## Contributing

1. Fork it ( http://github.com/<my-github-username>/rails-mblox/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
