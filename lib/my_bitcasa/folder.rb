require 'my_bitcasa/item'

module MyBitcasa
  class Folder < Item
    def ls
      Ls.new(self.path)
    end
  end
end
