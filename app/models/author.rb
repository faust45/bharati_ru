class Author < BaseModel
  unique_id :slug

  property :full_name
  property :display_name
  property :description

  as_slug :display_name

  has_attachment :main_photo, AuthorMainPhotoStore
  #has_attachments :photos, AuthorPhotoStore

  view_by :full_name
  view_by :display_name

  search_index <<-JS
    if(doc['couchrest-type'] && doc['couchrest-type'] == 'Author') {
      var ret = new Document();
      ret.add(doc.display_name, {"store": "yes"});
      return ret;
    }
  JS

  def self.get_by_name_or_create(display_name)
    authors = by_display_name(:key => display_name)

    unless authors.blank?
      authors.first
    else
      create(:display_name => display_name)
    end
  end

end
