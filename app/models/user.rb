class User < BaseModel
  include ZeroAuth

  class AccessDenided < Exception
  end


  property :age
  property :settings, :type => HHash, :default => HHash.new 

  view_by :login

  #has_attachment :photo

  def can_add_bookmark?(bm)
    !is_owner?(bm)
  end

  def update_settings(attrs)
    settings.merge!(attrs)
    self.save_without_callbacks
  end

  def get_audio_bookmark!(id)
    bm = AudioBookmark.get!(id)
    is_owner!(bm)

    bm
  end

  def copy_bookmark(id)
    bm = AudioBookmark.get!(id)
    new_bm = bm.copy
    self << new_bm
    new_bm.save

    new_bm
  end

  def bookmarks_for(audio)
    AudioBookmark.find_by_owner_and_audio(self.id, audio.id)
  end

  def is_owner?(item)
    self.id == item.owner_id
  end

  def is_owner!(item)
    raise Doc::NotFound unless is_owner?(item) 
  end

  def <<(item)
    item.owner_id = self.id

    if item.respond_to?(:owner_display_name)
      item.owner_display_name = self.login
    end
  end

end
