require 'my_bitcasa/bitcasa_base'

module MyBitcasa
  class BitcasaShare < BitcasaBase
    data_reader :short_url
    data_reader :id
    data_reader :key
    
    def long_url
      "https://my.bitcasa.com/send/#{self.id}/#{self.key}"
    end
  end
end
