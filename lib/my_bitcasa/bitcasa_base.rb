require 'my_bitcasa/item_accessor'

module MyBitcasa
  class BitcasaBase
    extend ItemAccessor

    def initialize(item)
      @item = item
    end
  end
end
