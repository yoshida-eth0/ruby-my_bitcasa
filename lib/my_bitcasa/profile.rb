require 'my_bitcasa/connection_pool'

module MyBitcasa
  class Profile < Hash
    include ConnectionPool

    def initialize
      renew!
    end

    def renew!
      res = connection.get "/profile"
      self.clear
      self.merge!(res.body)
    end

    [
      :last_name,
      :usage_str,
      :plan_type,
      :quota,
      :button1_url,
      :first_name,
      :days_left,
      :created_at,
      :button1,
      :state,
      :storage_used,
      :state_id,
      :email,
    ].each do |key|
      class_eval %{
        def #{key}
          self["#{key}"]
        end
      }
    end
  end
end
