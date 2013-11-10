require 'my_bitcasa/bitcasa_folder'

module MyBitcasa
  class BitcasaDrive < BitcasaFolder
    item_reader :mount_point
    item_reader :deleted?
    item_reader :mirrored?
    item_reader :origin_device
    item_reader :origin_device_id
    item_reader :sync_type
  end
end
