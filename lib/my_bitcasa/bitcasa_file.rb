require 'my_bitcasa/bitcasa_item'
require 'my_bitcasa/downloadable'
require 'my_bitcasa/thumbnail'
require 'my_bitcasa/legacy_thumbnail'
require 'my_bitcasa/rename'
require 'my_bitcasa/delete'
require 'my_bitcasa/share'

module MyBitcasa
  class BitcasaFile < BitcasaItem
    include Downloadable

    data_reader :album
    data_reader :extension
    data_reader :artist
    data_reader :duplicates
    data_reader :manifest_name
    data_reader :mime
    data_reader :id
    data_reader :incomplete?
    data_reader :size

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

    def rename(to_basename)
      to_basename = File.basename(to_basename)
      to = File.dirname(self.path) + "/" + to_basename
      Rename.new(self.path, to).rename
      @item["path"] = to
      @item["name"] = to_basename
      self
    end

    def delete
      Delete.new(self.path).delete
      @item["deleted"] = true
      true
    end

    def share
      Share.new(self.name, self.path).share
    end
  end
end
