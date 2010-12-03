class AlbumPublication < AlbumBase
  CLASSIC = ['ClassicalLiterature']
  VAISHNAVA = %w(scriptures ShrimadBhagavatam BiographiesOfTheSaints VaishnavaPrayers BhaktivedantaBooks)

  property :main_photo
  property :publications, [], :default => []

  class <<self
    def get_all
      view_docs('albums_publication_all')
    end

    def get_classic
      get_all_docs(CLASSIC)
    end

    def get_vaishnava
      get_all_docs(VAISHNAVA)
    end

    def get_by_author(author_id)
      view_docs('albums_by_author', :key => author_id)
    end
  end

  def get_publications
    Publication.get_all_docs(self.publications)
  end

  def cover
    main_photo
  end

end
