BetterErrors::Middleware.allow_ip! "192.168.50.50" if defined?(BetterErrors) && Rails.env == :development
