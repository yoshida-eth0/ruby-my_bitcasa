require 'my_bitcasa/connection_pool'
require 'json'

module MyBitcasa
  class Delete
    include ConnectionPool

    def initialize(*paths)
      @paths = paths
    end

    def delete
      res = connection.post do |req|
        req.url "/delete"
        req.body = {
          selection: JSON.generate({
            paths: @paths,
            albums: {},
            artists: [],
            photo_albums: {},
          }),
        }
      end
    end
  end
end
