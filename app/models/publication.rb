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


  class<<self
    def get_all(options = {})
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
  end

  def cover
    if self['cover_attachments']
      self['cover_attachments'][0]
    end
  end

  def created_at
    self.when_uploaded
  end

end
