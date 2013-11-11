require 'active_support/core_ext'
require 'cgi'
require 'fileutils'
require 'tempfile'

module MyBitcasa
  module Downloadable
    extend ActiveSupport::Concern

    def stream(&block)
      # path
      uri = _download_path
      query = _download_params.map{|k,v|
        "#{k}=#{CGI.escape(v.to_s)}"
      }.join("&")

      # headers
      headers = connection.headers.dup
      headers["Cookie"] = connection.cookie

      # request
      http = Net::HTTP.new(connection.url_prefix.host, connection.url_prefix.port)
      http.use_ssl = connection.url_prefix.scheme=="https"

      http.request_get(uri+"?"+query, headers) do |res|
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

    def download(dest_path, use_tempfile=true)
      # normalize dest path
      if File.directory?(dest_path)
        dest_path = dest_path.sub(/\/?$/, "/") + _download_basename
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

    # downloadable info

    def _download_path
      path_proc = self.class.downloadable_path_proc
      instance_eval &path_proc
    end
    private :_download_path

    def _download_params
      params_proc = self.class.downloadable_params_proc
      instance_eval &params_proc
    end
    private :_download_params

    def _download_basename
      basename_proc = self.class.downloadable_basename_proc
      instance_eval &basename_proc
    end
    private :_download_basename

    module ClassMethods
      attr_reader :downloadable_path_proc
      attr_reader :downloadable_params_proc
      attr_reader :downloadable_basename_proc

      def downloadable_path(&block)
        @downloadable_path_proc = block
      end

      def downloadable_params(&block)
        @downloadable_params_proc = block
      end

      def downloadable_basename(&block)
        @downloadable_basename_proc = block
      end
    end
  end
end
