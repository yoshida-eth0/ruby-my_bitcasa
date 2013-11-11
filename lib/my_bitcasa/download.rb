require 'my_bitcasa/connection_pool'
require 'cgi'
require 'fileutils'
require 'tempfile'

module MyBitcasa
  class Download
    include ConnectionPool

    def initialize(path, params, basename)
      @path = path
      @params = params
      @basename = basename
    end

    def stream(&block)
      # path
      query = @params.map{|k,v|
        "#{k}=#{CGI.escape(v.to_s)}"
      }.join("&")

      # headers
      headers = connection.headers.dup
      headers["Cookie"] = connection.cookie

      # request
      http = Net::HTTP.new(connection.url_prefix.host, connection.url_prefix.port)
      http.use_ssl = connection.url_prefix.scheme=="https"

      http.request_get(@path+"?"+query, headers) do |res|
        case res
        when Net::HTTPSuccess
          # 200 OK
        when Net::HTTPUnauthorized
          # 401 Auhorization error
          raise AuthorizationError, "login required"
        else
          # other status
          raise ConnectionError, "response status code: #{res.code}"
        end
        res.read_body(&block)
      end
    end

    def save(dest_path, use_tempfile=true)
      # normalize dest path
      if File.directory?(dest_path)
        dest_path = dest_path.sub(/\/?$/, "/") + @basename
      end

      # check dest dir
      dest_dir = File.dirname(dest_path)
      unless File.directory?(dest_dir)
        raise Errno::ENOENT, "No such directory - #{dest_dir}"
      end
      unless File.writable?(dest_dir)
        raise Errno::EACCES, "Permission denied - #{dest_dir}"
      end

      # download
      if use_tempfile
        # use tempfile
        temp_path = nil
        begin
          Tempfile.open("bitcasa_tempfile_") {|f|
            temp_path = f.path
            self.stream {|x|
              f.write(x)
            }
          }
          FileUtils.mv(temp_path, dest_path)
        ensure
          if temp_path && File.file?(temp_path)
            File.unlink(temp_path) rescue nil
          end
        end
      else
        # direct write
        open(dest_path, "w") {|f|
          self.stream {|x|
            f.write(x)
          }
        }
      end

      # chmod
      File.chmod(0644, dest_path)

      dest_path
    end
  end
end
