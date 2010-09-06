class Audio < MediaContent

  property :duration

  has_attachment :source, SourceAudioAttachmentStore
  #has_attachments :photos

  after_save_source_attachment :assign_meta_info


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
    source.delete_attachment()
    source_attachments.reject!{|el|
      el.doc_id == source_id
    }
  end

  private
    def assign_meta_info
      self.title = source_doc.title
      self.record_date = source_doc.record_date
      self.tags = source_doc.tags
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

end
