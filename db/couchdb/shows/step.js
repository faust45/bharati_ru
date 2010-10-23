function(doc) {
  var fileName;
  for(fileName in doc._attachments) {
  }
  var id = doc._id;
  var location = "http://93.94.152.87:3000/rocks_file_store_dev/" + id + "/" + fileName;
 
  return {"code": 302, "body": "See other", "headers": {"Location": location}};
}
