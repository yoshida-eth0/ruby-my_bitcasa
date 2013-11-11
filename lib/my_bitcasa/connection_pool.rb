require 'my_bitcasa/connection'
require 'active_support/core_ext'

module MyBitcasa
  module ConnectionPool
    extend ActiveSupport::Concern

    attr_writer :connection

    def connection
      @connection || self.class.connection
    end

    def multipart_connection
      connection.multipart
    end

    module ClassMethods
      mattr_accessor :connection

      def establish_connection(*args)
        @@connection = Connection.new(*args)
      end
    end
  end
end
