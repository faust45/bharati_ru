class Audio < MediaContent

  property :duration

  has_attachment :source, :content_type => 'audio/mpeg' do |file|
    info = Mp3Info.open(file.path, :encoding => 'utf-8')

    @is_need_update_info ||= true
    if @is_need_update_info
      info_tags = info.tag2
      assign_from_tags(info_tags)
    end

    self.duration = calc_duration(info)
  end

  has_attachment :photos


  def albums
    @albums ||= Album.by_albums_by_track(:key => self.id)
  end

  def source_replace(file, is_need_update_info = false)
    @is_need_update_info = is_need_update_info
    source_delete
    update_attributes(:source_file => file)
  end

  def source_delete
    source_id = source.doc_id
    source.delete
    source_attachments.reject!{|el|
      el.doc_id == source_id
    }
  end

  def shared_bookmarks
    AudioBookmark.find_shared(self.id)
  end

  def new_bookmark(options = {})
    bm = AudioBookmark.new(options)
    bm.audio_id = self.id
    bm
  end

  def assign_from_tags(info)
    self.assign_title_and_record_date(info['TT2'])
    self.assign_author(info['TP1'])
    self.assign_tags(info['TCM'])
    self.add_to_album(info['TAL'])
  end  

  protected
    def assign_author(name)
      unless name.blank?
        self.set_author(Author.get_by_name_or_create(name))
      end
    end

    def assign_tags(tags)
      unless tags.blank?
        tags = tags.split(',')
        tags = tags.map(&:strip)
        self.tags = tags unless tags.blank?
      end
    end

    def add_to_album(name)
      unless name.blank?
        name.strip!
        name.sub!(/\.$/, '')

        album = Album.get_by_name_or_create(name)
        album << self
      end
    end

    def assign_title_and_record_date(title_and_record_date)
      unless title_and_record_date.blank?
        m_date = title_and_record_date.match(/\d{4}\.\d{2}\.\d{2}/)
        if m_date
          self.record_date = Date.parse(m_date[0]) 
          self.title = title_and_record_date.sub(m_date[0], '')
        else
          self.title = title_and_record_date
        end

        self.title.strip!
        self.title.sub!(/\.$/, '')
      end
    end

  private
    def calc_duration(info)
      l = info.length
      mins = l.divmod(60)

      if mins[0] == 0
        min = mins[0]
        sec = mins[1].round
      else
        min = mins[0]
        sec = mins[1].round
      end
    
      (min * 60 + sec) * 1000
    end

end
