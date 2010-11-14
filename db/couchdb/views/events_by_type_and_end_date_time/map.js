function(doc) {
  if(doc['couchrest-type'] == 'Event') {
    if (doc.end_date) {
      emit([doc.event_type, doc.end_date + ' ' + doc.end_time], null);
    } else {
      emit([doc.event_type, {}], null);
    }
  }
}
