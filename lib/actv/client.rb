require 'faraday'
require 'active_support/core_ext/hash/indifferent_access'
require 'actv/article'
require 'actv/article_search_results'
require 'actv/asset'
require 'actv/asset_factory'
require 'actv/author'
require 'actv/configurable'
require 'actv/error/forbidden'
require 'actv/error/not_found'
require 'actv/event'
require 'actv/event_result'
require 'actv/asset_stats_result'
require 'actv/evergreen'
require 'actv/sub_event'
require 'actv/search_results'
require 'actv/event_search_results'
require 'actv/popular_interest_search_results'
require 'actv/user'
require 'actv/organizer'
require 'actv/organizer_results'
require 'actv/quiz'
require 'actv/quiz_outcome'
require 'actv/quiz_question'
require 'actv/quiz_question_answer'
require 'actv/video'
require 'actv/video_search_results'
require 'actv/validators/article_validator'
require 'actv/validators/asset_validator'
require 'actv/validators/author_validator'
require 'actv/validators/event_validator'
require 'actv/validators/quiz_validator'
require 'actv/validators/quiz_outcome_validator'
require 'actv/validators/quiz_question_validator'
require 'actv/validators/quiz_question_answer_validator'
require 'actv/validators/video_validator'
require 'simple_oauth'
module ACTV
  # Wrapper for the ACTV REST API
  #
  # @note
  class Client
    include ACTV::Configurable

    attr_reader :oauth_token

    # Initialized a new Client object
    #
    # @param options [Hash]
    # @return[ACTV::Client]
    def initialize(options={})
      ACTV::Configurable.keys.each do |key|
        instance_variable_set("@#{key}", options[key] || ACTV.options[key])
      end
    end

    # Returns assets that match a specified query.
    #
    # @authentication_required No
    # @param q [String] A search term.
    # @param options [Hash] A customizable set of options.
    # @return [ACTV::SearchResults] Return assets that match a specified query with search metadata
    # @example Returns assets related to running
    #   ACTV.assets('running')
    #   ACTV.search('running')
    def assets(q, params={})
      response = get("/v2/search.json", params.merge(query: q))
      ACTV::SearchResults.from_response(response)
    end
    alias search assets

    def asset id, params={}
      params = params.with_indifferent_access
      is_preview = params.delete(:preview) == "true"
      response = request_response id, params, is_preview
      asset_from_response response
    end

    # Returns an organizer with the specified ID
    #
    # @authentication_required No
    # @return ACTV::Organizer The requested organizer.
    # @param id [String] An assset ID.
    # @param options [Hash] A customizable set of options.
    # @example Return the organizer with the id AA388860-2718-4B20-B380-8F939596B123
    #   ACTV.organizer("AA388860-2718-4B20-B380-8F939596B123")
    def organizer(id, params={})
      response = get("/v3/organizers/#{id}.json", params)
      ACTV::Organizer.from_response response
    end


    # Returns all organizers
    #
    # @authentication_required No
    # @param options [Hash] A customizable set of options.
    # @return [ACTV::Organizer] Return organizations
    # @example Returns organizers
    #   ACTV.organizers
    #   ACTV.organizers({per_page: 8, current_page: 2})
    def organizers(params={})
      response = get("/v3/organizers.json", params)
      ACTV::OrganizerResults.from_response response
    end

    # Returns an asset with the specified url path
    #
    # @authentication_required No
    # @return [ACTV::Asset] The requested asset
    # @param path [String]
    # @example Return an asset with the url http://www.active.com/miami-fl/running/miami-marathon-and-half-marathon-2014
    #   ACTV.asset_by_path("http://www.active.com/miami-fl/running/miami-marathon-and-half-marathon-2014")
    def find_asset_by_url(url)
      url_md5 = Digest::MD5.hexdigest(url)
      response = get("/v2/seourls/#{url_md5}?load_asset=true")

      ACTV::Asset.from_response(response)
    end

    def find_by_endurance_id endurance_id
      response = get "/v2/search.json", find_by_endurance_id_params(endurance_id)
      ACTV::SearchResults.from_response(response).results.select do |asset|
        asset.registrationUrlAdr.end_with?(endurance_id.to_s) and asset.assetParentAsset[:assetGuid].nil?
      end
    end

    # Returns articles that match a specified query.
    #
    # @authentication_required No
    # @param q [String] A search term.
    # @param options [Hash] A customizable set of options.
    # @return [ACTV::SearchResults] Return articles that match a specified query with search metadata
    # @example Returns articles related to running
    #   ACTV.articles('running')
    #   ACTV.articles('running')
    def articles(q, params={})
      response = get("/v2/search.json", params.merge({query: q, category: 'articles'}))
      ACTV::ArticleSearchResults.from_response(response)
    end

    # Returns an article with the specified ID
    #
    # @authentication_required No
    # @return [ACTV::Article] The requested article.
    # @param id [String] An article ID.
    # @param options [Hash] A customizable set of options.
    # @example Return the article with the id BA288960-2718-4B20-B380-8F939596B123
    #   ACTV.article("BA288960-2718-4B20-B380-8F939596B123")
    def article id, params={}
      request_string = "/v2/assets/#{id}"
      is_preview, params = params_include_preview? params
      request_string += '/preview' if is_preview

      response = get "#{request_string}.json", params

      article = ACTV::Article.new response[:body]
      article.is_article? ? article : nil
    end

    def events(q, params={})
      response = get("/v2/search.json", params.merge({query: q, category: 'event'}))
      ACTV::EventSearchResults.from_response(response)
    end

    def event(id, params={})
      request_string = "/v2/assets/#{id}"
      is_preview, params = params_include_preview? params
      request_string += '/preview' if is_preview

      response = get("#{request_string}.json", params)

      if response[:body].is_a? Array
        response[:body].map do |item|
          ACTV::Event.new item
        end
      else
        event = ACTV::Event.new response[:body]
        event = ACTV::Evergreen.new(event) if event.evergreen?
        event.is_article? ? nil : event
      end
    end

    def video(id, params={})
      request_string = "/v2/assets/#{id}"
      response = get "#{request_string}.json", params

      ACTV::Video.new response[:body]
    end

    def videos(q, params={})
      response = get("/v2/search.json", params.merge({query: q, category: 'videos'}))
      ACTV::VideoSearchResults.from_response(response)
    end

    # Returns popular assets that match a specified query.
    #
    # @authentication_required No
    # @param options [Hash] A customizable set of options.
    # @return [ACTV::SearchResults] Return events that match a specified query with search metadata
    # @example Returns articles related to running
    #   ACTV.popular_events()
    #   ACTV.popular_events("topic:running")
    def popular_events(params={})
      response = get("/v2/events/popular", params)
      ACTV::SearchResults.from_response(response)
    end

    # Returns upcoming assets that match a specified query.
    #
    # @authentication_required No
    # @param options [Hash] A customizable set of options.
    # @return [ACTV::SearchResults] Return events that match a specified query with search metadata
    # @example Returns articles related to running
    #   ACTV.upcoming_events()
    #   ACTV.upcoming_events("topic:running")
    def upcoming_events(params={})
      response = get("/v2/events/upcoming", params)
      ACTV::SearchResults.from_response(response)
    end

    # Returns popular assets that match a specified query.
    #
    # @authentication_required No
    # @param options [Hash] A customizable set of options.
    # @return [ACTV::SearchResults] Return events that match a specified query with search metadata
    # @example Returns articles related to running
    #   ACTV.popular_articles()
    #   ACTV.popular_articles("topic:running")
    def popular_articles(params={})
      response = get("/v2/articles/popular", params)
      ACTV::ArticleSearchResults.from_response(response)
    end

    # Returns popular interests
    #
    # @authentication_required No
    # @param options [Hash] A customizable set of options.
    # @return [ACTV::PopularInterestSearchResults] Return intersts
    # @example Returns most popular interests
    #   ACTV.popular_interests()
    #   ACTV.popular_interests({per_page: 8})
    def popular_interests(params={}, options={})
      response = get("/interest/_search", params, options)
      ACTV::PopularInterestSearchResults.from_response(response)
    end

    # Returns popular searches
    #
    # @authentication_required No
    # @param options [Hash] A customizable set of options.
    # @return [ACTV::PopularSearchSearchResults] Return searches
    # @example Returns most popular searches
    #   ACTV.popular_searches()
    #   ACTV.popular_searches({per_page: 8})
    def popular_searches(options={})
      #response = get("/v2/articles/popular", params)
      #ACTV::ArticleSearchResults.from_response(response)
      ["Couch to 5k","Kids' Camps","Swimming Classes","Half Marathons in Southern CA","Gyms in Solana Beach","Dignissim Qui Blandit","Dolore Te Feugait","Lorem Ipsum","Convnetio Ibidem","Aliquam Jugis"]
    end

    # Returns a result with the specified asset ID and asset type ID
    #
    # @authentication_required No
    # @return [ACTV::EventResult] The requested event result.
    # @param assetId [String] An asset ID.
    # @param assetTypeId [String] An asset type ID.
    # @example Return the result with the assetId 286F5731-9800-4C6E-ADD5-0E3B72392CA7 and assetTypeId 3BF82BBE-CF88-4E8C-A56F-78F5CE87E4C6
    #   ACTV.event_results("286F5731-9800-4C6E-ADD5-0E3B72392CA7","3BF82BBE-CF88-4E8C-A56F-78F5CE87E4C6")
    def event_results(assetId, assetTypeId, options={})
      begin
        response = get("/api/v1/events/#{assetId}/#{assetTypeId}.json", {}, options)
        ACTV::EventResult.from_response(response)
      rescue
        nil
      end
    end

    def asset_stats asset_id
      response = get("/v2/assets/#{asset_id}/stats")
      ACTV::AssetStatsResult.new response[:body]
    end

    # Returns the currently logged in user
    #
    # @authentication_required Yes
    # @return [ACTV::User] The requested current user.
    # @param options [Hash] A customizable set of options.
    # @example Return current_user if authentication was susccessful
    #   ACTV.me
    def me(params={})
      response = get("/v2/me.json", params)
      user = ACTV::User.from_response(response)
      user.access_token =  @oauth_token
      user
    end

    def update_me(user, params={})
      response = put("/v2/me.json", params.merge(user))
      user = ACTV::User.from_response(response)
      user.access_token =  @oauth_token
      user
    end

    def user_name_exists?(user_name, params={})
      get("/v2/users/user_name/#{user_name}", params)[:body][:exists]
    end

    def display_name_exists?(display_name, params={})
      get("/v2/users/display_name/#{URI.escape(display_name)}", params)[:body][:exists]
    end

    def is_advantage_member?(options={})
      get("/v2/me/is_advantage_member", options)[:body][:is_advantage_member]
    end

    def avatar_url(options={})
      get("/v2/me/avatar_url", options)[:body][:avatar_url]
    end

    # Perform an HTTP GET request
    def get(path, params={}, options={})
      request(:get, path, params, options)
    end

    # Perform an HTTP POST request
    def post(path, params={}, options={})
      request(:post, path, params, options)
    end

    # Perform an HTTP UPDATE request
    def put(path, params={}, options={})
      request(:put, path, params, options)
    end

    # Perform an HTTP DELETE request
    def delete(path, params={}, options={})
      request(:delete, path, params, options)
    end

    # Returns a Faraday::Connection object
    #
    # @return [Faraday::Connection]
    def connection
      @connection ||= Faraday.new(@endpoint, @connection_options.merge(:builder => @middleware))
    end

    # Perform an HTTP Request
    def request(method, path, params, options)
      uri = options[:endpoint] || @endpoint
      uri = URI(uri) unless uri.respond_to?(:host)
      uri += path
      request_headers = {}
      params[:api_key] = @api_key unless @api_key.nil?

      if self.credentials?
        # When posting a file, don't sign any params
        signature_params = if [:post, :put].include?(method.to_sym) && params.values.any?{|value| value.is_a?(File) || (value.is_a?(Hash) && (value[:io].is_a?(IO) || value[:io].is_a?(StringIO)))}
          {}
        else
          params
        end
        authorization = SimpleOAuth::Header.new(method, uri, signature_params, credentials)
        request_headers[:authorization] = authorization.to_s.sub('OAuth', "Bearer")
      end
      connection.url_prefix = options[:endpoint] || @endpoint
      connection.run_request(method.to_sym, path, nil, request_headers) do |request|
        unless params.empty?
          case request.method
          when :post, :put
            request.body = params
          else
            request.params.update(params)
          end
        end
        yield request if block_given?
      end.env
    rescue Faraday::Error::ClientError
      raise ACTV::Error::ClientError
    end
    # Check whether credentials are present
    #
    # @return [Boolean]
    def credentials?
      credentials.values.all?
    end

    private

    def request_response id, params, is_preview
      if is_preview
        asset_response_with_preview id, params
      else
        asset_response_without_preview id, params
      end
    end

    def asset_response_with_preview id, params
      request_string = "/v2/assets/#{id}/preview"
      get "#{request_string}.json", params
    end

    def asset_response_without_preview id, params
      request_string = "/v2/assets"
      params = params.merge :id => id
      post "#{request_string}.json", params
    end

    def asset_from_response response
      if response[:body].is_a? Array
        collect_assets response
      else
        Array(ACTV::Asset.from_response response)
      end
    end

    def collect_assets response
      response[:body].map do |response|
        ACTV::Asset.from_response body: response
      end
    end

    def find_by_endurance_id_params endurance_id
      awe_legacy_guid = 'DFAA997A-D591-44CA-9FB7-BF4A4C8984F1'
      params = {
        'asset.registrationUrlAdr' => endurance_id.to_s,
        'asset.sourceSystem.legacyGuid' => awe_legacy_guid,
        'searchable_only' => false
      }
    end

    # Credentials hash
    #
    # @return [Hash]
    def credentials
      {
        # :consumer_key => @consumer_key,
        # :consumer_secret => @consumer_secret,
        :token => @oauth_token
        # :token_secret => @oauth_token_secret,
      }
    end

    def params_include_preview? params
      params = params.with_indifferent_access
      return params.delete(:preview) == "true", params
    end
  end
end
