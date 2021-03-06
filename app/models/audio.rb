class Audio < MediaContent
  use_time_id

  property :duration
  property :bookmarks, [HHash], :default => [] #:time :str_time :name
  property :extracts, [], :default => []

  has_attachment  :source, SourceAudioAttachmentStore
  has_attachments :photos, BigPhotoStore

  after_create_source_attachment  :assign_meta_info
  after_replace_source_attachment :assign_meta_info, :if => :is_source_need_update_meta_info?

  before_destroy :drop_from_albums
  before_destroy :source_destroy

  
  class <<self
    def get_all(options = {})
      options[:descending] ||= true
      view_docs('audios_all', options)
    end

    def get_by_author(author_id, options = {})
      options[:key] = author_id
      options[:descending] ||= true 
      view_docs('audios_by_author', options)
    end

    def get_by_author_and_year(author_id, year, options = {})
      options[:startkey] = [author_id, year]
      options[:endkey]   = [author_id, year, {}, {}]

      view_docs('audios_by_author_and_record_date', options)
    end

    def get_by_author_and_year_month(author_id, year, month)
      options = {
        :startkey => [author_id, year, month], 
        :endkey   => [author_id, year, month, {}]
      }
      view_docs('audios_by_author_and_record_date', options)
    end

    def get_by_tag(tag)
      view_docs('audios_by_tag', :key => tag)
    end

    def get_by_album(album_id)
      view_docs('album_tracks', :startkey => [album_id], :endkey => [album_id, {}])
    end
    
    def count
      resp = view('audios_all', :reduce => true)
      resp['rows'][0]['value']
    end

    def search(q, params = {})
      per_page = 10
      options = {}
      options[:include_docs] = true

      page = (params[:page] || 1).to_i
      options[:limit] = per_page
      options[:skip] = (page - 1) * per_page

      query = "(title:#{q} OR tags:#{q} OR bookmarks:#{q})"
      if !params[:author_id].blank? && !params[:year].blank?
        query = "author_id: #{params[:author_id]} AND year:#{params[:year]} AND " + query
      elsif !params[:author_id].blank?
        query = "author_id:#{params[:author_id]} AND " + query
      elsif !params[:album_id].blank?
        album = Album.get_doc!(params[:album_id])
        tracks = album.tracks.join(' ')
        query = "(#{tracks}) AND " + query
      end

      options[:q] = query
      resp = database.search(design_doc.id + '/audios', options)
      Collection.new(resp, self)
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

  def from_bhagavatam
    books = SbAlbum.get_by_track(self.id)

    if books.any?
      books.first
    end
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

  def extracts_raw
    self.extracts
  end

  def extracts_raw=(value)
    unless value.blank?
      result = []
      a = value.split("\n")
      a.each do |item|
        item.strip!
        item.sub!(/^"/, '')
        item.sub!(/"$/, '')
        result << item unless item.blank?
      end

      self.extracts = result 
    end
  end

  private
    def drop_from_albums
      Album.get_by_track(self.id).each do |album|
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
