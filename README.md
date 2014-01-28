[![Build Status](https://travis-ci.org/activenetwork/actv.png)](https://travis-ci.org/activenetwork/actv)

# ACTV

A Ruby wrapper for The ACTIVE Network 3.0 API. You can get your v2
search API key at http://developer.active.com

## Installation

Add this line to your application's Gemfile:

    gem 'actv'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install actv

## Configuration

Require the gem, then configure the endpoint and your api key:

    ACTV.configure do |config|
      config.endpoint = "http://api.amp.active.com"
      config.api_key = "YOUR_API_KEY"
    end

## Usage Examples

Search for Running

    ACTV.search('Running')

Return an Asset with Id of 12345678-9012-3456-7890-123456789012

    ACTV.asset('12345678-9012-3456-7890-123456789012')

Search for Swimming Articles

    ACTV.articles('Swimming')

Return an Article with Id of 12345678-9012-3456-7890-123456789012

    ACTV.article('12345678-9012-3456-7890-123456789012')

Certain methods require authentication. You need to instantiate a Client object with a valid acceess token

    @actv = ACTV::Client.new({
        oauth_token: session[:access_token]
    })

Get the requested current user

    @actv.me

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
