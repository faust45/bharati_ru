function(doc, req) {
  if(doc._attachments) {
    for(file in doc._attachments) {
      if (doc._attachments[file]['content_type'] == 'audio/mpeg' && doc.need_fetch_tags) {
        return true;
      }
    }
  }

  return false;
}
