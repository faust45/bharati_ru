function(doc) {
  if(doc['couchrest-type'] == 'Event') {
    emit(null, null);
  }
}
