function(doc) {
  if(doc['couchrest-type'] == 'Audio') {
    emit(null, null);
  }
}
