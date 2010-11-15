function() {
  var photoPrefix = $(this).attr('data-photo');
  var photo = EditDocForm.getMainPhoto(photoPrefix);

  if (photo.isExists) {
    return {imgId: photo.id + '?round=1&' + getRand()}
  } else {
    return {};
  }
}
