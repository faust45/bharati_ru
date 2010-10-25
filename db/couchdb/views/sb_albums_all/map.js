function(doc) {
  if(doc['couchrest-type'] == 'SbAlbum') {
    emit(parseInt(doc.book_num), null);
  }
}
