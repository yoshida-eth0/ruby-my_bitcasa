require 'my_bitcasa/connection_pool'
require 'my_bitcasa/bitcasa_share'

module MyBitcasa
  class Share
    include ConnectionPool

    def initialize(name, *paths)
      @name = name
      @paths = paths.flatten
    end

    def share
      res = connection.post do |req|
        req.url "/share"
        req.body = {
          name: @name,
          selection: JSON.generate({
            paths: @paths,
            albums: {},
            artists: [],
            photo_albums: [],
          }),
        }
      end

      BitcasaShare.new(res.body)
    end
  end
end
