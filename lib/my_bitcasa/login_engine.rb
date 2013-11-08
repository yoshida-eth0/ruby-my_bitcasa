require 'my_bitcasa/login_engine/phantomjs'
require 'my_bitcasa/login_engine/selenium'

module MyBitcasa
  module LoginEngine
    class << self
      def autodetect
        [Phantomjs, Selenium].each do |engine|
          return engine if engine.available?
        end
        raise RuntimeError, "available login engine is not found"
      end
    end
  end
end
