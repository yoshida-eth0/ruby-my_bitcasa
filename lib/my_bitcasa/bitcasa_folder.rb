require 'my_bitcasa/bitcasa_item'
require 'my_bitcasa/connection_pool'
require 'my_bitcasa/upload'
require 'my_bitcasa/mkdir'
require 'my_bitcasa/rename'
require 'my_bitcasa/delete'
require 'my_bitcasa/share'

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

    def mkdir(basename)
      path = "#{self.path}/#{basename}"
      Mkdir.new(path).mkdir
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
