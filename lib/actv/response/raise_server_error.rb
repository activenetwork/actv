require 'faraday'
require 'actv/error/bad_gateway'
require 'actv/error/internal_server_error'
require 'actv/error/service_unavailable'

module ACTV
  module Response
    class RaiseServerError < Faraday::Response::Middleware

      def on_complete(env)
        status_code = env[:status].to_i
        error_message = JSON.parse(env[:body])["error"]["message"]
        error_class = ACTV::Error::ServerError.errors[status_code]
        raise error_class.new(error_message) if error_class
      end

    end
  end
end
