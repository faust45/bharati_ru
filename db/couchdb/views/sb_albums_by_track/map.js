function(doc) {
  if(doc['couchrest-type'] == 'SbAlbum') {
    if(doc.tracks) {
       for(i in doc.tracks) {
         emit(doc.tracks[i], null);
       };
     }
  }
}
