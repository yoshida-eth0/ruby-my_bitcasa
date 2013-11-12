$LOAD_PATH << File.expand_path("../lib", File.dirname(__FILE__))

require 'my_bitcasa'
require 'yaml'
require 'pp'

setting = YAML.load_file(File.expand_path("setting.yml", File.dirname(__FILE__)))
MyBitcasa.establish_connection(setting.symbolize_keys)

drive = MyBitcasa::Directory.new("/").select{|item| item.drive?}.first

drive.each do |item|
  if item.name.match(/^my_bitcasa_example_/)
    puts "name: #{item.name}"
    share = item.share
    puts "share url: #{share.short_url}"
    puts "-----"
  end
end
