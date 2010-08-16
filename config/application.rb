require File.expand_path('../boot', __FILE__)

# Pick the frameworks you want:
require 'rails/all'
require 'bcrypt'

# require 'action_mailer/railtie'
# require 'active_resource/railtie'
# require 'rails/test_unit/railtie'


# Auto-require default libraries and those for the current Rails environment.
Bundler.require :default, Rails.env

module MahaMandala
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Add additional load paths for your own custom dirs
    config.autoload_paths += %W( #{config.root}/lib )

    # Only load the plugins named here, in the order given (default is alphabetical).
    # :all can be used as a placeholder for all plugins not explicitly named
    # config.plugins = [ :exception_notification, :ssl_requirement, :all ]

    # Activate observers that should always be running
    # config.active_record.observers = :cacher, :garbage_collector, :forum_observer

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}')]
    # config.i18n.default_locale = :de

    # Configure generators values. Many other options are available, be sure to check the documentation.
     config.generators do |g|
       g.orm             :active_record
       g.template_engine :erb
       g.test_framework  :rspec
     end

    # Configure sensitive parameters which will be filtered from the log file.
    config.filter_parameters << :password
    config.secret_token = "some secret phrase of at least 30 characters"
    config.session_store :cookie_store, 
     :key    => '_maha_mandala_session',
     :secret => 'b90ada47c5aa27373329b427f8e9613cb73f8b47b7c458bc4ec01af6f7ef084dd99356c0a279e24c44aec188aefe21ae491ef06791b9a95da349598a8272825f',
     :expire_after => 1.week 
  end
end
