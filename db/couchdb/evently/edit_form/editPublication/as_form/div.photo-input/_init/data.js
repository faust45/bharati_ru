function() {
  var doc = EditDocForm.currentDoc; 

  if (img = doc.cover_attachments) {
    return {img: doc.cover_attachments[0]}
  } else {
    return {};
  }
}
