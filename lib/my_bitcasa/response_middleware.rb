require 'json'
require 'faraday_middleware/response_middleware'
require 'my_bitcasa/connection_error'
require 'my_bitcasa/authorization_error'

module MyBitcasa
  class ResponseMiddleware < FaradayMiddleware::ResponseMiddleware
    def process_response(env)
      # check status code
      case env[:status]
      when 200
        # 200 OK
      when 401
        # 401 Auhorization error
        raise AuthorizationError, "login required"
      else
        # other status
        raise ConnectionError, "response status code: #{env[:status]}"
      end

      # parse json
      case env[:body]
      when "OK"
        # OK string
      else
        # parse json
        begin
          env[:body] = JSON.parse(env[:body])
        rescue => e
          e2 =ResponseFormatError.new("#{e.class}: #{e.message}")
          e2.set_backtrace(e.backtrace)
          raise e2
        end
      end
    end
  end
end

Faraday::Response.register_middleware :my_bitcasa => MyBitcasa::ResponseMiddleware
