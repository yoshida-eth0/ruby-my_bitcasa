# connection
require 'my_bitcasa/connection'
require 'my_bitcasa/connection_pool'
require 'my_bitcasa/login_engine'

# api
require 'my_bitcasa/profile'
require 'my_bitcasa/ls'
require 'my_bitcasa/download'
require 'my_bitcasa/zip_download'
require 'my_bitcasa/upload'
require 'my_bitcasa/delete'
require 'my_bitcasa/thumbnail'
require 'my_bitcasa/legacy_thumbnail'

# model
require 'my_bitcasa/item_accessor'
require 'my_bitcasa/bitcasa_item'
require 'my_bitcasa/bitcasa_drive'
require 'my_bitcasa/bitcasa_folder'
require 'my_bitcasa/bitcasa_file'

# error
require 'my_bitcasa/error'
require 'my_bitcasa/connection_error'
require 'my_bitcasa/authorization_error'
require 'my_bitcasa/response_format_error'

module MyBitcasa
    include ConnectionPool
end
