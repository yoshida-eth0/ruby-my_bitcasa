module MyBitcasa
  module LoginEngine
    # MyBitcasa::LoginEngine::Pure is not work.
    class Pure
      include ConnectionPool

      attr_reader :cookie

      def initialize(connection=nil)
        @connection = connection
      end

      def login(user, password)
        # login form
        res = @conn.get_without_loggedin("/login")

        csrf_tag = res.body.match(/<input [^<>]*name="csrf_token"[^<>]*>/){|m| m[0]}
        raise ResponseError, "csrf_token tag is not found" unless csrf_tag

        csrf_token = csrf_tag.match(/value="([^"]+)"/){|m| m[1]}
        raise ResponseError, "csrf_token is not found" unless csrf_token

        # login post
        res = @conn.post_without_loggedin("/login", {
          user: user,
          password: password,
          csrf_token: csrf_token,
          redirect: "/",
        })

        if res.env[:url].path.start_with?("/login")
          raise AuthorizationError, "login failure"
        end

        @cookie = res.headers["set-cookie"]
      end

      class << self
        def available?
          false
        end
      end
    end
  end
end
