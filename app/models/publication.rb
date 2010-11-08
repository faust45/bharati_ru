class Publication < Content

  TYPES = [:book, :article]

  use_as_id :when_uploaded

  property :ipaper_id
  property :ipaper_access_key
  property :when_uploaded, Time
  property :page_count
  property :translator_id
  property :genre
  property :publication_type

  before_create :ipaper_id_uniq


  class<<self
    def get_all(options = {})
      options[:descending] ||= true
      view_docs('publications_all', options)
    end

    def get_by_author_or_translator(id, options = {})
      options[:key] = id
      view_docs('publications_by_author_or_translator', options)
    end

    def get_articles_by_author(author_id, options)
      options[:key] = author_id
      view_docs('articles_by_author', options)
    end

    def get_books_by_author(author_id, options)
      options[:key] = author_id
      view_docs('books_by_author', options)
    end

    def get_all_bhagavatam(options = {})
      view_docs('publication_bhagavatam', options)
    end

    def get_by_ipaper_id(ipaper_id)
      view_docs('publications_by_ipaper_id', :key => ipaper_id)
    end

    def exists?(doc)
      get_by_ipaper_id(doc.ipaper_id).any?
    end
  end

  def cover
    if self['cover_attachments']
      self['cover_attachments'][0]
    end
  end

  def created_at
    self.when_uploaded
  end

  private
    def ipaper_id_uniq
      if Publication.exists?(self)
        raise Dublicate 
      end
    end

    class Dublicate < Exception; end

end
