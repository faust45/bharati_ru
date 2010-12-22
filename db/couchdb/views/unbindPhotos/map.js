function(doc) {
  if (doc.type == 'Photo') {
    emit(doc._id, null);
  }

  if (doc.type == 'PhotoAlbum' && doc.photos) {
    for(var i in doc.photos) {
      emit(doc.photos[i], null);
    }
  }
}
