function(doc) {
  if(doc['couchrest-type'] == 'AlbumPublication') {
    emit(null, null);
  }
}
