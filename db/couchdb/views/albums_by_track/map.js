function(doc) {
  if(doc['couchrest-type'] == 'Album' || doc['couchrest-type'] == 'SbAlbum') {
    if(doc.tracks) {
       for(var i in doc.tracks) {
         emit(doc.tracks[i], null);
       };
     }
  }
}
