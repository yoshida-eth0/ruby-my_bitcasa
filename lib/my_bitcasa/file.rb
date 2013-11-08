require 'my_bitcasa/item'
require 'my_bitcasa/connection_pool'

module MyBitcasa
  class File < Item
    include ConnectionPool

    [
      :album,
      :extension,
      :artist,
      :duplicates,
      :manifest_name,
      :mime,
      :id,
      :incomplete,
      :size,
    ].each do |key|
      class_eval %{
        def #{key}
          @item["#{key}"]
        end
      }
    end

    def thumbnail(size=:small)
      Thumbnail.new(self, size)
    end

    def binary
      @binary ||= begin
        res = self.get do |req|
          req.url "/file/#{self.id}"
          req.params = {
            size: self.size,
            mime: self.mime,
          }
        end
        res.body
      end
    end
  end
end
