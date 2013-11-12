require 'my_bitcasa/bitcasa_folder'

module MyBitcasa
  class BitcasaDrive < BitcasaFolder
    data_reader :mount_point
    data_reader :deleted?
    data_reader :mirrored?
    data_reader :origin_device
    data_reader :origin_device_id
    data_reader :sync_type

    undef_method :rename
    undef_method :delete
  end
end
