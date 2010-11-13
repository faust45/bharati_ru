function(doc) {
  if(doc['couchrest-type'] == 'AlbumPublication') {
    if(doc.publications) {
       for(i in doc.publications) {
         emit(doc.publications[i], null);
       };
     }
  }
}
