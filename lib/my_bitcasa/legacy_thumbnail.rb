require 'my_bitcasa/connection_pool'
require 'my_bitcasa/downloadable'

module MyBitcasa
  class LegacyThumbnail
    include ConnectionPool
    include Downloadable

    THUMB_SIZE = {
      small: "35x35c",
      medium: "150x150c",
      large: "260x260c",
      preview: "1024x768s",
    }.freeze

    downloadable_path {
      "/file/#{@file.id}/thumbnail/#{@specific_size}.png"
    }
    downloadable_params {{
      size: @file.size,
      mime: @file.mime,
    }}
    downloadable_basename {
      name = File.basename(@file.name, "."+@file.extension)
      "#{name}_#{@specific_size}.png"
    }

    def initialize(file, size=:small)
      @file = file
      @specific_size = THUMB_SIZE[size] || size
    end
  end
end
