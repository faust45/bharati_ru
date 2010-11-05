function() {
  var doc = EditDocForm.currentDoc; 

  if (img = doc.cover_attachments) {
    return {imgId: img[0] + '?' + getRand()}
  } else {
    return {};
  }
}
