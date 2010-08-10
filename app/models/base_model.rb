SERVER = CouchRest.new('http://faust45:cool@192.168.1.100:5984')
MAIN_DB_NAME = 'rocks'
DB     = SERVER.database!(MAIN_DB_NAME)

module Doc
  class CannotDestroy < Exception
  end

  NotFound = RestClient::ResourceNotFound
end

class BaseModel < CouchRest::Model::Base
  include DirtyBehavior
  include Attachments
  include Slug 
  include Search

  use_database DB


  class <<self
    def delete_all
      all.each do |doc|
        doc.destroy
      end
    end

    def use_rand_id
      before_save do
        if new?
          self[:_id] = (rand(99999999) + 1).to_s
        end
      end
    end

    def logger
      Rails.logger
    end

    def use_db(db_name)
      db = SERVER.database!("#{MAIN_DB_NAME}_#{db_name}")
      use_database db
    end
  end

  def make_copy 
    attributes = self.to_hash.dup
    attributes.delete('_id')
    attributes.delete('_rev')

    a = self.class.new(attributes)
    a
  end

  def attributes
    self
  end

  def reload
    unless new?
      self.class.get(self.id)
    end
  end

 end
