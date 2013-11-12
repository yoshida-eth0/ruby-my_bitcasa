$LOAD_PATH << File.expand_path("../lib", File.dirname(__FILE__))

require 'my_bitcasa'
require 'yaml'
require 'pp'

setting = YAML.load_file(File.expand_path("setting.yml", File.dirname(__FILE__)))
MyBitcasa.establish_connection(setting.symbolize_keys)

def recursive(path, remainder, &block)
  MyBitcasa::Directory.new(path).each do |item|
    if item.folder?
      recursive(item.path, remainder-1, &block) if 0<remainder
    else
      yield item
    end
  end
end

photo_paths = enum_for(:recursive).each("/", 1).select {|item|
  item.category=="photos"
}.map {|item|
  item.path
}

MyBitcasa::ZipDownload.new(photo_paths).save("./")
