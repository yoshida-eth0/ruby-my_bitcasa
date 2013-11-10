require 'my_bitcasa/item_accessor'

module MyBitcasa
  class BitcasaItem
    extend ItemAccessor

    item_reader :category
    item_reader :name
    item_reader :mirrored?
    item_reader :mtime
    item_reader :path
    item_reader :type

    def initialize(item)
      @item = item
    end

    def drive?
      folder? && !!self.mount_point
    end

    def folder?
      self.category=="folders"
    end

    def file?
      !folder?
    end

    class << self
      def create(item)
        if item["category"]=="folders"
          if item["mount_point"]
            BitcasaDrive.new(item)
          else
            BitcasaFolder.new(item)
          end
        else
          BitcasaFile.new(item)
        end
      end
    end
  end
end
