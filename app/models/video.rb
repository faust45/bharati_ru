class Video < MediaContent
  use_db 'videos'

  property :title
  property :duration
  property :upload_date
  property :url
  property :height
  property :width
  property :thumbnail_small
  property :thumbnail_medium
  property :thumbnail_large


  view_by :tag, :map => <<-MAP
    function(doc) {
      if (doc['couchrest-type'] == 'Video' && doc.tags) {
        doc.tags.forEach(function(tag) {
          emit(tag, 1);
        });
      }
    }
  MAP

  class <<self
  end

end
