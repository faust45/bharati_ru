function() {
  var photoType = $(this).attr('data-photo') || "vertical";
  var photo = EditDocForm.getMainPhoto(photoType);

  if (!photo.isBlank) {
    return {imgId: photo.id + '?round=1&' + getRand()}
  } else {
    return {};
  }
}
