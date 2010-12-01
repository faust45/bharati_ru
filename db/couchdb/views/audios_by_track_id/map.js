function(doc) {
  if(doc['couchrest-type'] == 'Audio' && doc.source_attachments) {
    for(var i in doc.source_attachments) {
      var attach = doc.source_attachments[i];
      emit(attach.doc_id, null);
    }
  }
}
