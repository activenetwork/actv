# ACTV

A Ruby wrapper for The ACTIVE Network 3.0 API

## Installation

Add this line to your application's Gemfile:

    gem 'actv'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install actv

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
    
## Changelog

###v1.0.4
- Basic implementation of ACTV::Article
- Added ability to find articles by Id
- Added ability to search for articles
- Added Summary and Description attributes to ACTV::Asset

###v1.0.3
- Address now extends ACTV::Base instead of ACTV::Identity

### v1.0.2
- Basic implementation of ACTV::User
- Added method to return current user
- Added ability to search assets
- Basic implementation of ACTV::SearchResults
- Bubbling up client errors correctly

### v1.0.1
- New class ACTV::AssetImage
- ACTV::Asset.images returns an array of AssetImages
- Added method_missing and respond_to? to ACTV::Base to allow access to arbitrary attributes

### v1.0.0
- Basic ACTV::Asset implementation
- Basic Base object implementation
- HTTP Request implementation

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
