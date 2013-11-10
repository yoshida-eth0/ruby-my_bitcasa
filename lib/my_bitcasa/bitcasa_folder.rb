require 'my_bitcasa/bitcasa_item'

module MyBitcasa
  class BitcasaFolder < BitcasaItem
    def ls
      Ls.new(self.path)
    end
  end
end
