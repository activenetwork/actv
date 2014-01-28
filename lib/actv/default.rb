require 'faraday'
require 'actv/configurable'
require 'actv/request/multipart_with_file'
require 'actv/response/parse_json'
require 'actv/response/raise_client_error'
require 'actv/response/raise_server_error'
# require 'twitter/response/rate_limit'
require 'actv/version'

module ACTV
  module Default
    class << self

      def options
        Hash[ACTV::Configurable.keys.map{|key| [key, send(key)]}]
      end

      # @note This is configurable in case you want to use HTTP instead of HTTPS or use a Active-compatible endpoint.
      # @see http://en.blog.wordpress.com/2009/12/12/twitter-api/
      # @see http://staff.tumblr.com/post/287703110/api
      # @see http://developer.typepad.com/typepad-twitter-api/twitter-api.html
      def endpoint
        @endpoint ||= 'http://api.amp.active.com'
      end

      def media_endpoint
        @media_endpoint ||= 'https://upload.active.com'
      end

      def search_endpoint
        @search_endpoint ||= 'https://search.active.com'
      end

      def connection_options
        @connection_options ||= {
          :headers => {
            :accept => 'application/json',
            :user_agent => "Active Ruby Gem #{ACTV::VERSION}"
          },
          :open_timeout => 5,
          :raw => true,
          :ssl => {:verify => false},
          :timeout => 10,
        }
      end

      # @note Faraday's middleware stack implementation is comparable to that of Rack middleware.  The order of middleware is important: the first middleware on the list wraps all others, while the last middleware is the innermost one.
      # @see https://github.com/technoweenie/faraday#advanced-middleware-usage
      # @see http://mislav.uniqpath.com/2011/07/faraday-advanced-http/
      def middleware
        @middleware ||= Faraday::Builder.new(
          &Proc.new do |builder|
            builder.use ACTV::Request::MultipartWithFile # Convert file uploads to Faraday::UploadIO objects
            builder.use Faraday::Request::Multipart         # Checks for files in the payload
            builder.use Faraday::Request::UrlEncoded        # Convert request params as "www-form-urlencoded"
            builder.use ACTV::Response::RaiseClientError # Handle 4xx server responses
            builder.use ACTV::Response::ParseJson        # Parse JSON response bodies using MultiJson
            builder.use ACTV::Response::RaiseServerError # Handle 5xx server responses
            # builder.use ACTV::Response::RateLimit        # Update RateLimit object
            builder.adapter Faraday.default_adapter         # Set Faraday's HTTP adapter
          end
        )
      end

      def consumer_key
        ENV['ACTV_CONSUMER_KEY']
      end

      def consumer_secret
        ENV['ACTV_CONSUMER_SECRET']
      end

      def oauth_token
        ENV['ACTV_OAUTH_TOKEN']
      end

      def oauth_token_secret
        ENV['ACTV_OAUTH_TOKEN_SECRET']
      end

      def api_key
        nil
      end

    end
  end
end
