class BaseModel < CouchRest::Model::Base
  include DB
  include ActiveSupport::Memoizable
  include Attachments
  include Slug 

  as_main_db

  class BlankDocId < Exception
  end


  class <<self
    def design_doc
      unless @ddoc
        @ddoc = database.get('_design/global')
        def @ddoc.save; end
      end

      @ddoc
    end

    def get_all_docs(keys)
      options = {:keys => Array(keys), :include_docs => true}
      resp = database.documents(options)
      Collection.new(resp, self, {:view => '_all_docs', :view_options => options}) 
    end

    def view(name, options = {})
      if viewFun = design_doc['views'][name]
        if viewFun['reduce']
          options[:reduce] ||= false
        end
      end

      path = "global/#{name}"

      ActiveSupport::Notifications.instrument("query.couchdb", :query => options.merge(:view => name)) do
        database.view(path, options)
      end
    end
    
    def view_docs(name, options = {})
      resp = view(name, options.merge(:include_docs => true))

      Collection.new(resp, self, {:view => name, :view_options => options})
    end

    def get_paginate_options(options = {})
      per_page = 10
      page = (options[:page] || 1).to_i

      {:skip => per_page * (page - 1), :limit => per_page}
    end

    def paginate(method, params = {})
      self.send(method, get_paginate_options(params))
    end

    def get_doc(id)
      raise BlankDocId if id.blank?
      get(id)
    end

    def get_doc!(id)
      raise BlankDocId if id.blank?
      get!(id)
    end

    def delete_all
      get_all.each do |doc|
        doc.destroy
      end
    end

    def use_time_id
      before_save do
        if new?
          self[:_id] = Time.now.to_couch_id
        end
      end
    end

    def use_rand_id
      before_save do
        if new?
          self[:_id] ||= (rand(99999999) + 1).to_s
        end
      end
    end

    def use_as_id(attr_name)
      before_create do
        if self['_id'].blank? 
          value = self.send(attr_name)
          self['_id'] = value.to_couch_id
        end
      end
    end

    def logger
      Rails.logger
    end
  end


  def view_docs(*args)
    self.class.view_docs(*args)
  end

  def view(*args)
    self.class.view(*args)
  end

  def paginate(method, params = {})
    self.send(method, self.class.get_paginate_options(params))
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
