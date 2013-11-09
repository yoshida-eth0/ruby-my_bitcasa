$LOAD_PATH << File.expand_path("../lib", File.dirname(__FILE__))

require 'my_bitcasa'
require 'yaml'
require 'pp'

setting = YAML.load_file(File.expand_path("setting.yml", File.dirname(__FILE__)))
MyBitcasa.establish_connection(setting["user"], setting["password"])

def recursive_download_photos(path, remainder)
  MyBitcasa::Ls.new(path).each do |item|
    if item.folder? && 0<remainder
      recursive_download_photos(item.path, remainder-1)
    elsif item.category=="photos"
      puts "name: #{item.name}"
      puts "path: #{item.path}"
      puts "-----"

=begin
      open(item.name, "w"){|f|
        item.stream {|x|
          f.write(x)
        }
      }
=end
      item.download(".")
    end
  end
end

recursive_download_photos("/", 1)
