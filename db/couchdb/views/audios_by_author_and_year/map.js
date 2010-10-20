function(doc) {
  if (doc['couchrest-type'] == 'Audio') {
    var year;
    if (doc.record_date) {
      var date = doc.record_date;

      year = date.slice(0, 4);
    }

    emit([doc.author_id, year], null);
  }
}
