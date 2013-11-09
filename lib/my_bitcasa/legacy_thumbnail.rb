require 'my_bitcasa/connection_pool'

module MyBitcasa
  class LegacyThumbnail
    include ConnectionPool

    THUMB_SIZE = {
      small: "35x35c",
      medium: "150x150c",
      large: "260x260c",
      preview: "1024x768s",
    }.freeze

    def initialize(file, size=:small)
      @file = file
      @specific_size = THUMB_SIZE[size] || size
    end

    def binary
      @binary ||= begin
        res = connection.get do |req|
          req.url "/file/#{@file.id}/thumbnail/#{@specific_size}.png"
          req.params = {
            size: @file.size,
            mime: @file.mime,
          }
        end
        res.body
      end
    end
  end
end
