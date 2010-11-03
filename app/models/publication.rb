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
  end

  def cover_attachments
    self['cover_attachments']
  end

  def created_at
    self.when_uploaded
  end

end
