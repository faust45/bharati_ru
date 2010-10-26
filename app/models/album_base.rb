class AlbumBase < BaseModel
  use_rand_id

  SORT_TYPE = [:custom, :by_date]

  property :title
  property :description
  property :author_id
  property :is_hand_sort, :default => false 
  property :tracks, [], :default => []

  timestamps!

  has_photo_attachment :cover, :thumb => {:size => 'x77'}

  def get_tracks
    Audio.get_by_album(self.id)
  end

  def author
    if self.author_id
      @author ||= Author.get_doc(author_id)
    end
  end

  def <<(content)
    self.tracks << content.id
    self.save
  end

  def >>(content_or_id)
    id =
      case content_or_id
      when String, Fixnum
        content_or_id.to_s
      else
        content_or_id.id
      end

    self.tracks.delete(id)
    self.save
  end
end
