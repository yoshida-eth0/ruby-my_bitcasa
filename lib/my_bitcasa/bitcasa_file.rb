require 'my_bitcasa/bitcasa_item'
require 'my_bitcasa/connection_pool'
require 'cgi'

module MyBitcasa
  class BitcasaFile < BitcasaItem
    include ConnectionPool

    [
      :album,
      :extension,
      :artist,
      :duplicates,
      :manifest_name,
      :mime,
      :id,
      :incomplete,
      :size,
    ].each do |key|
      class_eval %{
        def #{key}
          @item["#{key}"]
        end
      }
    end

    def thumbnail(size=:small)
      Thumbnail.new(self, size)
    end

    def binary
      @binary ||= begin
        res = connection.get do |req|
          req.url "/file/#{self.id}"
          req.params = {
            size: self.size,
            mime: self.mime,
          }
        end
        res.body
      end
    end

    def stream(&block)
      # path
      uri = "/file/#{self.id}"
      query = {
        size: self.size,
        mime: self.mime,
      }.map{|k,v|
        "#{k}=#{CGI.escape(v.to_s)}"
      }.join("&")

      # headers
      headers = connection.headers.dup
      headers["Cookie"] = connection.cookie

      # request
      http = Net::HTTP.new(connection.url_prefix.host, connection.url_prefix.port)
      http.use_ssl = connection.url_prefix.scheme=="https"

      http.request_get(uri+"?"+query, headers) do |res|
        unless Net::HTTPSuccess===res
          raise AuthorizationError, "login required" unless loggedin?
        end
        res.read_body(&block)
      end
    end

    def download(dest)
      if File.directory?(dest)
        dest += "/" + self.name
      end

      dest_dir = File.dirname(dest)
      unless File.exists?(dest_dir)
        raise Errno::ENOENT, "No such directory - #{dest_dir}"
      end

      open(dest, "w"){|f|
        self.stream {|x|
          f.write(x)
        }
      }
    end
  end
end
