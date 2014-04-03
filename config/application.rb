require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(:default, Rails.env)

module Pheasant
  class Application < Rails::Application
    
    config.active_record.default_timezone = :local
    config.time_zone = 'Tokyo'
    I18n.enforce_available_locales = false
    config.i18n.default_locale = :ja

    # Enable escaping HTML in JSON.
    config.active_support.escape_html_entities_in_json = true

    # Enable the asset pipeline
    config.assets.enabled = false

    # By default Rails API does not include the session middleware.
    # Add the middleware back in to application b/c it requred by Devise and Warden
    config.middleware.use ActionDispatch::Session::CookieStore
    config.middleware.use Rack::MethodOverride

    config.generators do |g|
      g.orm :active_record
      g.test_framework :rspec, fixture: true, fixture_replacement: :factory_girl
      g.view_specs false
      g.controller_specs true
      g.routing_specs true
      g.helper_specs false
      g.request_specs false
      g.assets false
      g.helper false
    end

    config.autoload_paths += %W(#{config.root}/lib)
    config.secret_key_base = YAML.load(File.open("#{Rails.root}/config/secrets.yml"))[Rails.env]['secret_key_base']
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de


    # config.middleware.insert_before ActionDispatch::Static, Rack::Cors do
    config.middleware.use Rack::Cors do
      allow do
        origins '*'
        resource '*', :headers => :any, :methods => [:get, :post, :put, :patch, :delete, :options]
      end
    end
  end
end
