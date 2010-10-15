class Audio < MediaContent
  use_time_id

  property :duration
  property :bookmarks, [HHash],:default => [] #:time :str_time :name

  has_attachment  :source, SourceAudioAttachmentStore
  has_attachments :photos, BigPhotoStore

  after_create_source_attachment  :assign_meta_info
  after_replace_source_attachment :assign_meta_info, :if => :is_source_need_update_meta_info?

  after_destroy :drop_from_albums
  after_destroy :source_destroy

  
  class <<self
    def get_all
      view_docs('audios_all')
    end

    def get_by_author(author_id)
      view_docs('audios_by_author', :key => author_id)
    end

    def get_by_author_and_year(author_id, year)
      options = {
        :startkey => [author_id, year], 
        :endkey   => [author_id, year, {}, {}]
      }
      view_docs('audios_by_author_and_record_date', options)
    end

    def get_by_tag(tag)
      view_docs('audios_by_tag', :key => tag)
    end

    def clean_up
      all.map{|e| database.delete_doc({'_id' => e['_id'], '_rev' => e['_rev']}) if e.title.blank? && e['_id']}
    end
  end


  def get_albums
    @albums ||= Album.get_by_track(self.id)
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
        m = str.match(/(\d{2}[.:]\d{2}[.:]\d{2})(.*)$/)
        m ||= str.match(/(\d{2}[.:]\d{2})(.*)$/)
        if m
          str_time = m[1].gsub('.', ':')
          self.bookmarks << {:str_time => str_time, :name => m[2].strip, :time => bm_time_ms(m[1])}
        else
          self.bookmarks << {:str_time => '', :name => str, :time => ''}
        end
      end
    end
  end

  private
    def drop_from_albums
      Album.by_track(:key => self.id).each do |album|
        album >> self
      end
    end

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
      if m = str_time.match(/(\d+)[.:](\d+)[.:](\d+)/)
        hour = m[1].to_i
        min  = m[2].to_i
        sec  = m[3].to_i
      else 
        m = str_time.match(/(\d+)[.:](\d+)/)
        hour = 0
        min  = m[1].to_i
        sec  = m[2].to_i
      end

  
      if m
        msec = ((hour * 60 * 60) + min * 60 + sec) * 1000
      end
    end

end
