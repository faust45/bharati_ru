class Author < BaseModel
  unique_id :slug

  property :full_name
  property :display_name
  property :description

  as_slug :display_name

  has_attachment :photo

  view_by :full_name
  view_by :display_name

  search_index <<-JS 
    if(doc['couchrest-type'] && doc['couchrest-type'] == 'Author') {
      var ret = new Document();
      ret.add(doc.display_name, {"store": "yes"});
      return ret;
    }
  JS

end
