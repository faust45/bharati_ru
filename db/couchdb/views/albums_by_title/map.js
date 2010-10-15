function(doc) {
  if(doc['couchrest-type'] == 'Album') {
    emit(doc.title, null);
  }
}
