require 'my_bitcasa/bitcasa_base'

module MyBitcasa
  class BitcasaItem < BitcasaBase
    data_reader :category
    data_reader :name
    data_reader :mirrored?
    data_reader :mtime
    data_reader :path
    data_reader :type

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
