class NilClass
  def any?
    false
  end
end

module DB 
  extend ActiveSupport::Concern

  class <<self
    def config
      unless @config
        @config = YAML::load(File.open("#{Rails.root}/config/couchdb.yml"))
        @config = HHash.new @config[Rails.env]
      end

      @config
    end

    def main_db
      server.database!(config.main_db)
    end

    def file_store_db
      server.database!(config.file_store_db)
    end


    def server
      CouchRest.new('http://192.168.1.100:5984')
    end
  end

  module ClassMethods
    def as_main_db
      use_database DB.main_db
    end

    def as_file_store
      use_database DB.file_store_db
    end
  end

end
