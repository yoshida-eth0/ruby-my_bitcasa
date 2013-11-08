require 'my_bitcasa/authorization_error'

module MyBitcasa
  module LoginEngine
    class Phantomjs
      attr_reader :cookie

      def initialize
        require 'phantomjs'
      end

      def login(user, password)
        js_path = File.expand_path("phantomjs_login.js", File.dirname(__FILE__))
        cookie = ::Phantomjs.run(js_path, user, password)
        cookie = cookie.to_s.strip
        if cookie.length==0
          raise AuthorizationError, "login failure"
        end
        @cookie = cookie
      end

      class << self
        def available?
          new && true rescue false
        end
      end
    end
  end
end
