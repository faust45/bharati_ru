function(doc) {
  if(doc['couchrest-type'] == 'Video') {
    emit(doc.author_id, null);
  }
}
