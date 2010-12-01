function(doc) {
  if (doc['couchrest-type'] == 'AudioBook') {
    emit(null, null);
  }
}
