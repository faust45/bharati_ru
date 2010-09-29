class VideoAlbum < BaseModel
  use_db 'videos'

  property :title
  property :description
  property :total_videos
  property :url
  property :videos, :default => []
  property :thumbnail_small
  property :thumbnail_medium
  property :thumbnail_large
  property :created_on
  property :last_modified

end
