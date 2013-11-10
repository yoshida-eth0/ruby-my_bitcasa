require 'my_bitcasa/connection_pool'
require 'my_bitcasa/downloadable'

module MyBitcasa
  class Thumbnail
    include ConnectionPool
    include Downloadable

    THUMB_SIZE = {
      small: "thumb_35x35.jpg",
      medium: "thumb_150x150.jpg",
      large: "thumb_260x260.jpg",
      preview: "preview_1024x768.jpg",
    }.freeze

    downloadable_path {
      "/transcode/#{@file.id}/#{@specific_size}"
    }
    downloadable_params {{
      size: @file.size,
      extension: @file.extension,
    }}
    downloadable_basename {
      name = File.basename(@file.name, "."+@file.extension)
      "#{name}_#{@specific_size}"
    }

    def initialize(file, size=:small)
      @file = file
      @specific_size = THUMB_SIZE[size] || size
    end
  end
end
