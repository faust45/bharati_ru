function(doc) {
  if(doc['couchrest-type'] == 'Publication') {
    emit(null, null);
  }
}
