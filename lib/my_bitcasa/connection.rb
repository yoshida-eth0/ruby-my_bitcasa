require 'my_bitcasa/connection_finalizer'
require 'my_bitcasa/response_format_error'
require 'my_bitcasa/connection_error'
require 'my_bitcasa/authorization_error'
require 'faraday'
require 'faraday_middleware'
require 'my_bitcasa/response_middleware'
require 'active_support/core_ext'
require 'uri'

module MyBitcasa
  class Connection < Faraday::Connection
    attr_writer :login_engine
    attr_accessor :cookie

    def initialize(user: nil, password: nil, multipart: false)
      super(:url => 'https://my.bitcasa.com') do |conn|
        conn.use FaradayMiddleware::FollowRedirects
        if multipart
          conn.request :multipart
        else
          conn.request :url_encoded
        end
        #conn.response :logger
        conn.response :my_bitcasa
        conn.adapter Faraday.default_adapter
      end 
      @headers[:user_agent] = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:10.0.2) Gecko/20100101 Firefox/10.0.2"

      yield self if block_given?

      login(user, password) if user && password
    ensure
      #ObjectSpace.define_finalizer(self) { logout! }
    end

    def login_engine
      @login_engine ||= LoginEngine.autodetect.new
    end

    def login(user, password)
      login_engine.login(user, password)
      @cookie = login_engine.cookie
    end

    def loggedin?
      !!@cookie
    end

    def logout!
      if loggedin?
        self.get("/logout")
        @cookie = nil
      end
    end

    [:get, :post, :put, :delete, :head, :patch].each do |method|
      class_eval %{
        def #{method}_with_session(*args, &block)
          res = #{method}_without_session(*args, &block)
          _after_request(:#{method}, res)
          res
        end
        alias_method_chain :#{method}, :session

        def #{method}_with_loggedin(*args, &block)
          _before_request(:#{method}, *args)
          res = #{method}_without_loggedin(*args) {|req|
            req.headers["Cookie"] = @cookie if @cookie
            block.call(req) if block
          }
          res
        end
        alias_method_chain :#{method}, :loggedin
      }
    end

    def multipart
      @multipart ||= self.class.new(multipart: true)
      @multipart.cookie = self.cookie
      @multipart
    end

    private
    def _before_request(method, *args)
      raise AuthorizationError, "login required" unless loggedin?
    end

    def _after_request(method, res)
      @cookie = res.headers["set-cookie"] || @cookie
      if @cookie
        @cookie.sub!(/; Domain=(\.?my)?.bitcasa.com; Path=\//, "")
      end
    end

    class << self
      def uri_encode(path)
        URI.encode(path).gsub("[", "%5B").gsub("]", "%5D")
      end
    end
  end
end
