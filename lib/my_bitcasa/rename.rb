require 'my_bitcasa/connection_pool'

module MyBitcasa
  class Rename
    include ConnectionPool

    def initialize(from, to)
      @from = from
      @to = to
    end

    def rename
      res = connection.post do |req|
        req.url "/rename/"
        req.body = {
          from: @from,
          to: @to,
        }
      end

      res.body
    end
  end
end
