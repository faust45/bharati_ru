class VideoAlbum < BaseModel

  property :title
  property :description
  property :total_videos
  property :url
  property :videos, :default => []
  property :thumbnail_small
  property :thumbnail_medium
  property :thumbnail_large
  property :created_on, Time
  property :last_modified


  class <<self
    def get_all(options = {})
      options[:descending] = true
      view_docs('video_albums_all', options)
    end
  end

end
