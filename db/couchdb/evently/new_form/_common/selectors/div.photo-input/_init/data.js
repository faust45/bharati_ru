function() {
  var doc = EditDocForm.doc();
  var photo = EditDocForm.photo();

  if (photo) {
    return {imgId: photo + '?round=1&' + getRand()}
  } else {
    return {};
  }
}
