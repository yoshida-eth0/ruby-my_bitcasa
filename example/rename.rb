$LOAD_PATH << File.expand_path("../lib", File.dirname(__FILE__))

require 'my_bitcasa'
require 'yaml'
require 'pp'

setting = YAML.load_file(File.expand_path("setting.yml", File.dirname(__FILE__)))
MyBitcasa.establish_connection(setting.symbolize_keys)

drive = MyBitcasa::Ls.new("/").select{|item| item.drive?}.first

drive.each do |item|
  if item.name.match(/^my_bitcasa_example_/)
    puts "from: #{item.name}"
    item.rename(item.name+"_rename")
    puts "to: #{item.name}"
    puts "-----"
  end
end
