# connection
require 'my_bitcasa/connection'
require 'my_bitcasa/connection_pool'
require 'my_bitcasa/login_engine'

# api
require 'my_bitcasa/profile'
require 'my_bitcasa/ls'
require 'my_bitcasa/delete'

# model
require 'my_bitcasa/item_accessor'
require 'my_bitcasa/bitcasa_item'
require 'my_bitcasa/bitcasa_drive'
require 'my_bitcasa/bitcasa_folder'
require 'my_bitcasa/bitcasa_file'
require 'my_bitcasa/thumbnail'
require 'my_bitcasa/legacy_thumbnail'

# error
require 'my_bitcasa/error'
require 'my_bitcasa/connection_error'
require 'my_bitcasa/authorization_error'

module MyBitcasa
    include ConnectionPool
end
