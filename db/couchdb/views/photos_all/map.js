function(doc) {
  if (doc['couchrest-type'] == 'Photo') {
    emit(null, null);
  }
}
