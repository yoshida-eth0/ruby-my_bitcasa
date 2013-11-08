module MyBitcasa
  class ConnectionFinalizer
    def initialize(conn)
      @conn = conn
    end

    def call(*args)
      puts "finalizer logout"
      @conn.logout!
    end
  end
end
