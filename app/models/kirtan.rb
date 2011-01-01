class Kirtan < BaseModel

  property :title
  property :tracks
  property :main_photo

  class <<self
    def get_all
      options = {}
      view_docs('kirtans', options)
    end
  end

  def get_tracks
    AudioBookTrack.get_all_docs(self.tracks)
  end

  def cover
    main_photo
  end

  def author
     @author ||= Author.get_doc(author_id)
  end
end
