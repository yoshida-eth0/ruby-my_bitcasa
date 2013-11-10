require 'my_bitcasa/bitcasa_item'
require 'my_bitcasa/connection_pool'
require 'my_bitcasa/downloadable'
require 'my_bitcasa/thumbnail'
require 'my_bitcasa/legacy_thumbnail'

module MyBitcasa
  class BitcasaFile < BitcasaItem
    include ConnectionPool
    include Downloadable

    item_reader :album
    item_reader :extension
    item_reader :artist
    item_reader :duplicates
    item_reader :manifest_name
    item_reader :mime
    item_reader :id
    item_reader :incomplete?
    item_reader :size

    downloadable_path {
      "/file/#{self.id}"
    }
    downloadable_params {{
      size: self.size,
      mime: self.mime,
    }}
    downloadable_basename {
      self.name
    }

    def thumbnail(size=:small)
      Thumbnail.new(self, size)
    end

    def legacy_thumbnail(size=:small)
      LegacyThumbnail.new(self, size)
    end
  end
end
