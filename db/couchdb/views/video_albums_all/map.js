function(doc) {
  if(doc['couchrest-type'] == 'VideoAlbum') {
    emit(null, null);
  }
}
