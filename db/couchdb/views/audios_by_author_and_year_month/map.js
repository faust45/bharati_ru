function(doc) {
  if (doc['couchrest-type'] == 'Audio') {
    var year, month;
    if (doc.record_date) {
      var date = doc.record_date;

      year  = date.slice(0, 4);
      month = date.slice(5, 7);
    }

    emit([doc.author_id, year, month], null);
  }
}
