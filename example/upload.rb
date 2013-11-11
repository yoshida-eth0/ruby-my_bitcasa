$LOAD_PATH << File.expand_path("../lib", File.dirname(__FILE__))

require 'my_bitcasa'
require 'yaml'
require 'pp'

setting = YAML.load_file(File.expand_path("setting.yml", File.dirname(__FILE__)))
MyBitcasa.establish_connection(setting.symbolize_keys)

drive = MyBitcasa::Ls.new("/").select{|item| item.drive?}.first

puts "src: #{__FILE__}"
puts "dest: #{drive.path}"
puts "-----"

file = drive.upload(__FILE__, filename: "my_bitcasa_example_upload.rb")
puts "name: #{file.name}"
puts "path: #{file.path}"
