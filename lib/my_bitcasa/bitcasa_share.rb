require 'my_bitcasa/bitcasa_base'

module MyBitcasa
  class BitcasaShare < BitcasaBase
    item_reader :short_url
    item_reader :id
    item_reader :key
    
    def long_url
      "https://my.bitcasa.com/send/#{self.id}/#{self.key}"
    end
  end
end
