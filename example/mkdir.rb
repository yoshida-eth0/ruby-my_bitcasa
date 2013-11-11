$LOAD_PATH << File.expand_path("../lib", File.dirname(__FILE__))

require 'my_bitcasa'
require 'yaml'
require 'pp'

setting = YAML.load_file(File.expand_path("setting.yml", File.dirname(__FILE__)))
MyBitcasa.establish_connection(setting.symbolize_keys)

drive = MyBitcasa::Ls.new("/").select{|item| item.drive?}.first

folder = drive.mkdir("my_bitcasa_example_mkdir")
puts "category: #{folder.category}"
puts "name: #{folder.name}"
puts "path: #{folder.path}"
