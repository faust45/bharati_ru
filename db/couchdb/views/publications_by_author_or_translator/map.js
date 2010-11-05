function(doc) {
  if(doc['couchrest-type'] == 'Publication') {
    emit(doc.author_id, null);
    emit(doc.translator_id, null);
  }
}
