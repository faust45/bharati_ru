class Audio < MediaContent

  property :duration
  property :bookmarks, [HHash],:default => [] #:time :name

  has_attachment :source, SourceAudioAttachmentStore
  has_attachments :photos, BigPhotoStore

  after_create_source_attachment  :assign_meta_info
  after_replace_source_attachment :assign_meta_info, :if => :is_source_need_update_meta_info?


  def albums
    @albums ||= Album.by_albums_by_track(:key => self.id)
  end

  def source_replace(new_file, is_need_update_info = false)
    @is_source_need_update_info = is_need_update_info
    update_attributes(:source_file => new_file)
  end

  def bookmarks_raw
    self.bookmarks.map do |v|
      "#{v['str_time']} #{v['name']}"
    end.join("\n")
  end

  def bookmarks_raw=(value)
    unless value.blank?
      a = value.split("\n")

      self.bookmarks = []
      a.each do |str|
        m = str.match(/(\d{2}:\d{2})(.*)$/)
        if m
          self.bookmarks << {:str_time => m[1], :name => m[2].strip, :time => bm_time_ms(m[1])}
        end
      end
    end
  end

  private
    def is_source_need_update_meta_info?
      @is_source_need_update_info = true if @is_source_need_update_info.nil?
      @is_source_need_update_info
    end

    def assign_meta_info
      self.title = source_doc.title
      self.record_date = source_doc.record_date
      self.tags = source_doc.tags
      self.duration = source_doc.duration

      assign_author(source_doc.author_name)
      add_to_album(source_doc.album_name)
    end
  
    def assign_author(author_name)
      unless author_name.blank?
        author = Author.get_by_name_or_create(author_name)
        self.set_author(author)
      end
    end
  
    def add_to_album(album_name)
      unless album_name.blank?
        album = Album.get_by_title_or_create(album_name)
        album << self
      end
    end

    def bm_time_ms(str_time)
      m = str_time.match(/(\d+):(\d+)/)
  
      if m
        min = m[1].to_i
        sec = m[2].to_i
  
        msec = (min * 60 + sec) * 1000
      end
    end

end
