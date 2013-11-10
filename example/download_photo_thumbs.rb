$LOAD_PATH << File.expand_path("../lib", File.dirname(__FILE__))

require 'my_bitcasa'
require 'yaml'
require 'pp'

setting = YAML.load_file(File.expand_path("setting.yml", File.dirname(__FILE__)))
MyBitcasa.establish_connection(setting["user"], setting["password"])

def recursive(path, remainder, &block)
  MyBitcasa::Ls.new(path).each do |item|
    if item.folder?
      recursive(item.path, remainder-1, &block) if 0<remainder
    else
      yield item
    end
  end
end

recursive("/", 1) do |item|
  if item.category=="photos"
    puts "name: #{item.name}"
    puts "path: #{item.path}"
    puts "saved: " + item.thumbnail.download("./")
    puts "-----"
  end
end
