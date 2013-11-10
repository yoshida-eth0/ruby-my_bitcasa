module MyBitcasa
  module ItemAccessor
    def item_value_reader(key)
      class_eval %{
        def #{key}
          @item["#{key}"]
        end
      }
    end 
    private :item_value_reader

    def item_bool_reader(key)
      class_eval %{
        def #{key}?
          !!@item["#{key}"]
        end
      }
    end 
    private :item_bool_reader

    def item_reader(key)
      key, question = key.to_s.split("?", -1)
      if question
        item_bool_reader(key)
      else
        item_value_reader(key)
      end
    end
    private :item_reader
  end
end
