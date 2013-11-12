require 'my_bitcasa/data_accessor'

module MyBitcasa
  class BitcasaBase
    extend DataAccessor

    def initialize(data)
      @data = data
    end
  end
end
