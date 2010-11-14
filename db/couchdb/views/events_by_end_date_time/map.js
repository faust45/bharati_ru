function(doc) {
  if(doc['couchrest-type'] == 'Event') {
    if (doc.end_date) {
      emit(doc.end_date + ' ' + doc.end_time, null);
    } else {
      emit({}, null);
    }
  }
}
