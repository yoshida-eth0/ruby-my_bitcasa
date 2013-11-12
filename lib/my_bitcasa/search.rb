require 'my_bitcasa/connection_pool'
require 'my_bitcasa/bitcasa_item'

module MyBitcasa
  class Search
    include ConnectionPool
    include Enumerable

    attr_accessor :search
    attr_accessor :top
    attr_accessor :bottom
    attr_accessor :sort_column
    attr_accessor :sort_ascending
    attr_accessor :seamless

    def initialize(search, top: 0, bottom: 500, sort_column: :name, sort_ascending: true, seamless: true)
      @search = search
      @top = top
      @bottom = bottom
      @sort_column = sort_column
      @sort_ascending = sort_ascending
      @seamless = seamless
    end

    def each
      top = @top

      begin
        res = connection.get {|req|
          req.url "/list/everything"
          req.params = {
            search: @search,
            top: top,
            bottom: @bottom,
            sort_column: @sort_column,
            sort_ascending: @sort_ascending,
          }
        }

        sentinel = res.body["sentinel"]
        length = res.body["length"]
        top = res.body["range"]["top"]
        bottom = res.body["range"]["bottom"]
        name = res.body["name"]
        items = res.body["items"]

        items.each do |item|
          yield BitcasaItem.create(item)
        end

        if length<=bottom
          break
        end
      end while @seamless
    end
  end
end
