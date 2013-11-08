module MyBitcasa
  module LoginEngine
    class Selenium
      attr_reader :cookie

      def initialize
        require 'selenium-webdriver'
        @use_headless = nil
      end

      def use_headless=(use)
        if use
          require 'headless'
        end
        @use_headless = use
      end

      def use_headless
        if @use_headless.nil?
          # autodetect
          begin
            require 'headless'
            Headless::CliUtil.ensure_application_exists!('Xvfb', 'Xvfb not found on your system')
            @use_headless = true
          rescue => e
            @use_headless = false
          end
        end

        @use_headless
      end

      def login(user, password)
        if use_headless
          login_with_headless(user, password)
        else
          login_without_headless(user, password)
        end
      end

      def login_with_headless(user, password)
        Headless.ly do
          login_without_headless(user, password)
        end
      end

      def login_without_headless(user, password)
        profile = ::Selenium::WebDriver::Firefox::Profile.new
        driver = ::Selenium::WebDriver.for :firefox, :profile => profile

        begin
          driver.navigate.to "https://my.bitcasa.com/login"

          input_user_tag = nil
          input_password_tag = nil

          5.times {
            sleep 1
            input_user_tag ||= driver.find_element(:xpath, "//input[@name='user']") || next
            input_password_tag ||= driver.find_element(:xpath, "//input[@name='password']") || next
            break
          }

          input_user_tag.send_keys(user)
          input_password_tag.send_keys(password)
          sleep 1

          input_password_tag.submit()
          sleep 3

          @cookie = driver.manage.all_cookies.map{|cookie|
            "#{cookie[:name]}=#{cookie[:value]}"
          }.join("; ")

        ensure
          driver.quit
        end
      end

      class << self
        def available?
          new && true rescue false
        end
      end
    end
  end
end
