require 'my_bitcasa/connection_pool'
require 'my_bitcasa/bitcasa_item'
require 'my_bitcasa/api_error'

module MyBitcasa
  class Mkdir
    include ConnectionPool

    def initialize(path)
      @path = path
    end

    def mkdir
      res = connection.post do |req|
        req.url "/directory#{@path}"
      end

      case res.body["status"]
      when "created"
        BitcasaItem.create(res.body["items"].first)
      else
        raise ApiError, "mkdir error: status=#{res.body["status"]} path=#{@path}"
      end
    end
  end
end
