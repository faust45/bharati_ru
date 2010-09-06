class Video < MediaContent

  Types = %w(lecture seminar appeal kirtan)

  #has_attachment :source

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
