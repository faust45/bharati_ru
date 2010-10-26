function(doc) {
  if(doc['couchrest-type'] == 'SbAlbum') {
    emit(parseFloat(doc.book_num), null);
  }
}
