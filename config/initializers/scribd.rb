module ScribdFu
  class Railtie < Rails::Railtie
    config.after_initialize do
      ScribdFu::ConfigPath = "#{Rails.root}/config/scribd_fu.yml".freeze
    end
  end
end
