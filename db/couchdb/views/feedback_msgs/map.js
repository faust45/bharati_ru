function(doc) {
  if (doc['couchrest-type'] == 'FeedbackMsg') {
    emit(null, null);
  }
}
