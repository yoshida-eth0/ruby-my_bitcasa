require 'my_bitcasa/download'
require 'json'

module MyBitcasa
  class ZipDownload < Download
    def initialize(paths)
      @path = "/download/File from My Drive.zip"
      @params = {}
      @body = {
        selection: JSON.generate({
          paths: paths,
          albums: {},
          artists: [],
          photo_albums: [],
        }),
      }
      @basename = "File from My Drive.zip"
      @req_class = Net::HTTP::Post
    end
  end
end
