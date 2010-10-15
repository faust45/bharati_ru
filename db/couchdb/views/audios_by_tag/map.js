function(doc) {
  if(doc['couchrest-type'] == 'Audio') {
    for(var i in doc.tags) {
      emit(doc.tags[i], null);
    }
  }
}
