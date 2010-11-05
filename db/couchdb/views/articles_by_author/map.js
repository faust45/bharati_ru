function(doc) {
  if(doc['couchrest-type'] == 'Publication' && doc.publication_type == 'article') {
    emit(doc.author_id, null);
  }
}
