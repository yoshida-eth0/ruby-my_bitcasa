require 'mime-types'

module MyBitcasa
  module Uploadable
    def upload(src_path, content_type: nil, filename: nil)
      # check src_path
      unless File.file?(src_path)
        raise Errno::ENOENT, "No such file - #{src_path}"
      end

      # check content_type
      unless content_type
        mime_type = MIME::Types.type_for(src_path).first
        if mime_type
          content_type = mime_type.to_s
        else
          content_type = 'application/octet-stream'
        end
      end

      # multipart connection
      res = multipart_connection.post do |req|
        req.url "/files"
        req.params = {
          path: self.path,
        }
        req.body = {
          file: Faraday::UploadIO.new(src_path, content_type, filename)
        }
      end

      BitcasaFile.new(res.body.first)
    end
  end
end
