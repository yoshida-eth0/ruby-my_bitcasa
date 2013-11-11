require 'my_bitcasa/bitcasa_item'
require 'my_bitcasa/connection_pool'
require 'my_bitcasa/uploadable'

module MyBitcasa
  class BitcasaFolder < BitcasaItem
    include Enumerable
    include ConnectionPool
    include Uploadable

    def each(&block)
      Ls.new(self.path).each(&block)
    end
  end
end
