module Search
  extend ActiveSupport::Concern

  class Index
    attr_reader :id, :name

    def initialize(db, namespace, name, body)
      @body = body
      @db = db
      @id = "_design/#{namespace}Search"
      @name = name
      @doc = HashWithIndifferentAccess.new(:_id => @id)
    end

    def path
      "#{@id}/#{@name}"
    end

    def save
      @function = "function(doc) {
          #{@body}
        }"

      @doc[:fulltext] = {@name => {:index => @function}}

      begin
        doc = @db.get(@id) 
        @doc[:_rev] = doc.rev
      rescue RestClient::ResourceNotFound
      end

      #@db.save_doc(@doc)

    #rescue RestClient::Conflict
      #DB.update_doc(@id, @doc)
    end

  end


  module ClassMethods
    def search_index(*args)
      args.unshift(:default) if args.size == 1

      index_name = args.shift
      body = args.shift

      index = Index.new(database, self.name, index_name, body)
      index.save

      @@all_index ||= {}
      @@all_index[index_name] = index
    end

    def search(q)
      database.search(default_index.path, {:q => "#{q}*"})['rows']
    end

    def default_index
      @@all_index[:default]
    end
  end

end
