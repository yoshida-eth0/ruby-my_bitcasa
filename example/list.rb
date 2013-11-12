$LOAD_PATH << File.expand_path("../lib", File.dirname(__FILE__))

require 'my_bitcasa'
require 'yaml'
require 'pp'

setting = YAML.load_file(File.expand_path("setting.yml", File.dirname(__FILE__)))
MyBitcasa.establish_connection(setting.symbolize_keys)

MyBitcasa::List.new(search: "my_bitcasa_example_").each do |item|
  puts "category: #{item.category}"
  puts "name: #{item.name}"
  puts "path: #{item.path}"
  puts "-----"
end
