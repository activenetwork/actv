## Changelog
###v1.0.20
- Basic implementation of ACTV::Event
- Added ability to find events by Id
- Added ability to search for events

###v.1.0.12
- Add author_footer to ACTV::Article
- fixed author_image/author_bio on ACTV::Article to pull correct info

###v.1.0.10
- Implemented fix to get authentication to work correctly through HTTP Headers

###v.1.0.9
- Implemented user_name and display_name existence check

###v1.0.8
- Basic implementation of ACTV::PhoneNumber
- ACTV::User.phone_number returns a PhoneNumber object
- Implemented code to give the ability to update current user

###v1.0.7
- Basic implementation of ACTV::AssetTopic
- ACTV::Asset.topics returns an array of AssetTopics

###v1.0.6
- Basic implemenetation of ACTV::AssetPrice
- ACTV::Asset.prices returns an array of AssetPrices
- Added footer and inline_ad attribute to ACTV::Article

###v1.0.5
- Basic implementation of ACTV::AssetComponent
- ACTV::Asset.components returns an array of AssetComponents
- Added link and target to ACTV::AssetImage

###v1.0.4
- Basic implementation of ACTV::Article
- Added ability to find articles by Id
- Added ability to search for articles
- Added Summary and Description attributes to ACTV::Asset
- Basic implementation of ACTV::AssetTag
- Basic implementation of ACTV::Tag
- ACTV::Asset.tags returns an array of AssetTags

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

