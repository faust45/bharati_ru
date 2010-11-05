function() {
  var doc = EditDocForm.currentDoc; 

  if (img = doc.main_photo_attachments_tmp) {
    return {imgId: img[0] + '?size=119x88&round=1&' + getRand()}
  } else {
    return {};
  }
}
