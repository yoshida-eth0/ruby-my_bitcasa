$LOAD_PATH << File.expand_path("../lib", File.dirname(__FILE__))

require 'my_bitcasa'
require 'yaml'
require 'pp'

setting = YAML.load_file(File.expand_path("setting.yml", File.dirname(__FILE__)))
MyBitcasa.establish_connection(setting.symbolize_keys)

puts "====="
puts "Root file list"
puts "====="
MyBitcasa::Direcoty.new("/").each do |item|
  pp item
end
