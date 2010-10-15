function(doc) {
  if(doc['couchrest-type'] == 'Audio') {
    emit(doc.author_id, null);
  }
}
