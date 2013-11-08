require 'my_bitcasa/connection'
require 'active_support/core_ext'

module MyBitcasa
  module ConnectionPool
    extend ActiveSupport::Concern

    attr_writer :connection

    def connection
      @connection || self.class.connection
    end

    module ClassMethods
      mattr_accessor :connection

      def establish_connection(user, password)
        @@connection = Connection.new(user, password)
      end
    end
  end
end
