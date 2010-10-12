SERVER = CouchRest.new('http://192.168.1.100:5984')
MAIN_DB_NAME = 'rocks'
DB     = SERVER.database!(MAIN_DB_NAME)

module Doc
  class CannotDestroy < Exception
  end

  NotFound = RestClient::ResourceNotFound
end

class BaseModel < CouchRest::Model::Base
  include ActiveSupport::Memoizable
  include Attachments
  include Slug 
  include Search

  use_database DB

  class BlankDocId < Exception
  end


  class <<self
    def get_doc(id)
      raise BlankDocId if id.blank?
      get(id)
    end

    def get_doc!(id)
      raise BlankDocId if id.blank?
      get!(id)
    end

    def delete_all
      all.each do |doc|
        doc.destroy
      end
    end

    def use_time_id
      before_save do
        if new?
          self[:_id] = Time.now.to_id
        end
      end
    end

    def use_rand_id
      before_save do
        if new?
          self[:_id] = (rand(99999999) + 1).to_s
        end
      end
    end

    def use_as_id(attr_name)
      before_create do
        if self['_id'].blank? 
          value = Russian::translit(self.send(attr_name))
          value.gsub!(/[^A-Za-z\d]/, '')
          self['_id'] = value
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

    def test(arr)
      arr.inject('0') do |prev, cur|
        #cur always must be > prev
        if prev <= cur
        else
          puts "test fail #{prev} < #{cur}"
          raise
        end

        cur 
      end
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
