function(doc) {
  if(doc['couchrest-type'] == 'Event') {
    if (doc.start_date) {
      var date = doc.start_date;

      year  = date.slice(0, 4);
      month = date.slice(5, 7);
      day   = date.slice(8, 10);

      emit([year, month, day], null);
    }
  }
}
