function() {
  var doc = EditDocForm.doc();
  var photoId = EditDocForm.getMainPhotoId();

  if (photoId) {
    return {imgId: photoId + '?round=1&' + getRand()}
  } else {
    return {};
  }
}
