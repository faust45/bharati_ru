function(doc) {
  if(doc['couchrest-type'] == 'Author') {
    emit(null, null);
  }
}
