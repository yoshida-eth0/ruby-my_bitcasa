require 'my_bitcasa/connection_pool'
require 'my_bitcasa/bitcasa_item'

module MyBitcasa
  class Ls
    include ConnectionPool
    include Enumerable

    attr_accessor :path
    attr_accessor :top
    attr_accessor :bottom
    attr_accessor :sort_column
    attr_accessor :sort_ascending
    attr_accessor :show_incomplete

    def initialize(path, top: 0, bottom: 500, sort_column: :name, sort_ascending: true, show_incomplete: true)
      @path = path.sub(/^\/?/, "/")
      @top = top
      @bottom = bottom
      @sort_column = sort_column
      @sort_ascending = sort_ascending
      @show_incomplete = show_incomplete
    end

    def each
      loop do
        res = connection.get {|req|
          req.url "/directory#{@path}"
          req.params = {
            top: @top,
            bottom: @bottom,
            sort_column: @sort_column,
            sort_ascending: @sort_ascending,
            "show-incomplete" => @show_incomplete,
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
      end
    end
  end
end
