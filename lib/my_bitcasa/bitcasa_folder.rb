require 'my_bitcasa/bitcasa_item'
require 'my_bitcasa/connection_pool'
require 'my_bitcasa/upload'

module MyBitcasa
  class BitcasaFolder < BitcasaItem
    include ConnectionPool
    include Enumerable

    def each(&block)
      Ls.new(self.path).each(&block)
    end

    def upload(src_path, content_type: nil, filename: nil)
      Upload.new(self.path).upload(src_path, content_type: content_type, filename: filename)
    end
    alias_method :<<, :upload
  end
end
