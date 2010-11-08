function(doc) {
  if(doc['couchrest-type'] == 'Publication') {
    emit(doc.ipaper_id, null);
  }
}
