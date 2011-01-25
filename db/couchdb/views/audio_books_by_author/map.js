function(doc) {
  if(doc.type == "AudioBook") {
    emit(doc.author_id, null);
  }
}
