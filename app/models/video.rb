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

  use_as_id :upload_at_and_rand

  before_create :assign_author
  before_create :assign_record_date


  class <<self
    def get_all(options = {})
      options[:descending] = true
      view_docs('videos_all', options)
    end

    def get_main
      db = database
      doc = db.get('events_main_album', :include_docs => true)
      resp = db.documents(:keys => doc['videos'] || [], :include_docs => true)
      Collection.new resp, self 
    end
    
    def get_by_author(author_id, options = {})
      options[:descending] = true
      options[:key] = author_id
      view_docs('videos_by_author', options)
    end

    def get_by_author_and_year(author_id, year, options = {})
      options[:startkey] = [author_id, year.to_s]
      options[:endkey]   = [author_id, year.to_s, {}, {}]

      view_docs('videos_by_auhtor_and_record_date', options)
    end

  end


  def to_s
    title
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

   def upload_at_and_rand
     unless upload_at.blank? 
       upload_at.to_time + rand(20).seconds
     end
   end

end
