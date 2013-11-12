module MyBitcasa
  module DataAccessor
    def data_value_reader(key)
      class_eval %{
        def #{key}
          @data["#{key}"]
        end
      }
    end 
    private :data_value_reader

    def data_bool_reader(key)
      class_eval %{
        def #{key}?
          !!@data["#{key}"]
        end
      }
    end 
    private :data_bool_reader

    def data_reader(key)
      key, question = key.to_s.split("?", -1)
      if question
        data_bool_reader(key)
      else
        data_value_reader(key)
      end
    end
    private :data_reader
  end
end
