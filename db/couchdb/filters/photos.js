function(doc, req) {
  if(doc._attachments && doc.type == 'Photo') {
    return true;
  } else {
    return false;
  }
}
