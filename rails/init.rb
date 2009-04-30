if RAILS_ENV == 'test'

  # Require webrat and configure it to work in Rails mode.
  require "webrat"

  Webrat.configure do |config|
    config.mode = :rails
  end
end
