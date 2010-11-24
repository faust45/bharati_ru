class Video < Content

  property :title
  property :vimeo_id
  property :duration
  property :record_date
  property :upload_at, Time
  property :url
  property :height
  property :width
  property :thumbnail_small
  property :thumbnail_medium
  property :thumbnail_large

  use_as_id :upload_at

  before_create :assign_author
  before_create :assign_record_date


  class <<self
    def get_all(options = {})
      options[:descending] = true
      view_docs('videos_all', options)
    end
  end


   def assign_author
     m = description.match(/author\:(.+)\<br\s\/\>/)
     m ||= description.match(/author\:(.+)/)

     if m
       author = m[1].strip
       id = Author.id_by_name(author)
       self[:author_id] = id if id
     end
   end

   def assign_record_date
     if m = description.match(/date\:(.+)$/)
       date = PartialDate.parse_ru(m[1])
       p date.to_s
       self[:record_date] = date.to_s if date 
     end
   end

end
