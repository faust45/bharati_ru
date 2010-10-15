function(doc) {
  if (doc['couchrest-type'] == 'Audio') {
    var year, month, day;
    if (doc.record_date) {
      var date = doc.record_date;

      year = date.slice(0, 4);
      mont = date.slice(5, 7);
      day  = date.slice(8, 10);
    }

    emit([doc.author_id, year, month, day], null);
  }
}
