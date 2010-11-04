function(doc) {
  if(doc['couchrest-type'] == 'Publication') {
    if(doc.title && doc.title.match(/Шримад Бхагаватам/)) {
      emit(null, null);
    }
  }
}
