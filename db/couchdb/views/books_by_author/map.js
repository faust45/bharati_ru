function(doc) {
  if(doc['couchrest-type'] == 'Publication' && doc.publication_type == 'book') {
    emit(doc.author_id, null);
  }
}
