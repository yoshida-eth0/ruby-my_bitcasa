require 'my_bitcasa/connection_pool'

module MyBitcasa
  class Thumbnail
    include ConnectionPool

    THUMB_SIZE = {
      small: "thumb_35x35.jpg",
      medium: "thumb_150x150.jpg",
      large: "thumb_260x260.jpg",
      preview: "preview_1024x768.jpg",
    }.freeze

    def initialize(file, size=:small)
      @file = file
      @specific_size = THUMB_SIZE[size] || size
    end

    def binary
      @binary ||= begin
        res = connection.get do |req|
          req.url "/transcode/#{@file.id}/#{@specific_size}"
          req.params = {
            size: @file.size,
            extension: @file.extension,
          }
        end
        res.body
      end
    end
  end
end
