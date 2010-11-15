function(doc) {
  if(doc['couchrest-type'] == 'Event') {
    var type, end;

    if (doc.end_date) {
      end = doc.end_date + ' ' + doc.end_time;
    } else {
      end = {};
    }

     
    emit([doc.event_type, end], null);
    emit(['any', end], null);
  }
}
