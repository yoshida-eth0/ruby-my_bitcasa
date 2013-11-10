module MyBitcasa
  class BitcasaItem
    def initialize(item)
      @item = item
    end

    def drive?
      folder? && !!@item["mount_point"]
    end

    def folder?
      @item["category"]=="folders"
    end

    def file?
      !folder?
    end

    [
      :category,
      :name,
      :mirrored,
      :mtime,
      :path,
      :type,
    ].each do |key|
      class_eval %{
        def #{key}
          @item["#{key}"]
        end
      }
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
