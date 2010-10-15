function(doc) {
  if(doc['couchrest-type'] == 'Album') {
    emit(doc.author_id, null);
  }
}
