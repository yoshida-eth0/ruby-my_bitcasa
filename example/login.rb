$LOAD_PATH << File.expand_path("../lib", File.dirname(__FILE__))

require 'my_bitcasa'
require 'yaml'
require 'pp'

setting = YAML.load_file(File.expand_path("setting.yml", File.dirname(__FILE__)))
MyBitcasa.establish_connection(setting["user"], setting["password"])

puts "====="
puts "Profile"
puts "====="

profile = MyBitcasa::Profile.new
pp profile
