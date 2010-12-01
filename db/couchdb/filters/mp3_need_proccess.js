function(doc, req) {
  if(doc._attachments) {
    for(file in doc._attachments) {
      if (doc._attachments[file]['content_type'] == 'audio/mpeg') {
        return true;
      }
    }
  }

  return false;
}
