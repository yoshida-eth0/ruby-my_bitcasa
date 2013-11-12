$LOAD_PATH << File.expand_path("../lib", File.dirname(__FILE__))

require 'my_bitcasa'
require 'yaml'
require 'pp'

setting = YAML.load_file(File.expand_path("setting.yml", File.dirname(__FILE__)))
MyBitcasa.establish_connection(setting.symbolize_keys)

puts "====="
puts "file list"
puts "====="

def recursive_directory(path, remainder)
  MyBitcasa::Directory.new(path).each do |item|
    puts "category: #{item.category}"
    puts "name: #{item.name}"
    puts "path: #{item.path}"
    puts "-----"

    if item.folder? && 0<remainder
      recursive_directory(item.path, remainder-1)
    end
  end
end

recursive_directory("/", 1)
