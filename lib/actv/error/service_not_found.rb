require 'actv/error/server_error'

module ACTV
  class Error
    # Raised when Active returns the HTTP status code 596
    class ServiceNotFound < ACTV::Error::ServerError
      HTTP_STATUS_CODE = 596
      MESSAGE = 'Service Not Found'
    end
  end
end
