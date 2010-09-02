class Audio < MediaContent

  property :duration

  has_attachment :source, SourceAudioAttachmentStore
  #has_attachments :photos


  def albums
    @albums ||= Album.by_albums_by_track(:key => self.id)
  end

  def has_meta_info?; true end

  def assign_meta_info(doc)
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
end
