require 'actv/error/server_error'

module ACTV
  class Error
    # Raised when Active returns the HTTP status code 504
    class GatewayTimeout < ACTV::Error::ServerError
      HTTP_STATUS_CODE = 504
      MESSAGE = 'Gateway Timeout'
    end
  end
end
