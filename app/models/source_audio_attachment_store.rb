class SourceAudioAttachmentStore < FileStore

  property :author_name
  property :album_name
  property :record_date, Date
  property :tags, :default => []
  property :duration


  private
    def assign_meta_info
      super

      info = Mp3Info.open(file.path, :encoding => 'utf-8')

      assign_from_tags(info.tag2)
      self.duration = calc_duration(info)
    end

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

    def assign_from_tags(info)
      self.assign_title_and_record_date(info['TT2'])
      self.assign_author(info['TP1'])
      self.assign_tags(info['TCM'])
      self.assign_album(info['TAL'])
    end  

    def assign_author(name)
      unless name.blank?
        self.author_name = name
      end
    end

    def assign_tags(tags)
      unless tags.blank?
        tags = tags.split(',')
        tags = tags.map(&:strip)
        self.tags = tags unless tags.blank?
      end
    end

    def assign_album(name)
      unless name.blank?
        name.strip!
        name.sub!(/\.$/, '')

        self.album_name = name 
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
end
