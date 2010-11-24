function(doc) {
  if(doc['couchrest-type'] == 'Video') {
    emit(null, null);
  }
}
