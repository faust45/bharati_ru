class AudioBook < BaseModel

  property :title
  property :tracks
  property :main_photo
  property :author_id
  property :translate_by
  property :muz_by
  property :read_by
  property :publications_link
  property :description
  property :keywords

  class <<self
    def get_all(options = {})
      view_docs('audio_books_all', options)
    end

    def vaishnava
      options = {:keys => Author::VAISHNAVA}
      view_docs('audio_books_by_author', options)
    end

    def classic
      options = {:keys => Author::CLASSIC}
      view_docs('audio_books_by_author', options)
    end
  end

  def to_s
    title
  end

  def get_tracks
    AudioBookTrack.get_all_docs(self.tracks)
  end

  def author_display_name 
    Author.display_name_by_id(author_id)
  end

  def cover
    main_photo
  end

end
