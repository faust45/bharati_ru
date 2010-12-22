function() {
  var photoPrefix = $(this).attr('data-photo');
  var container = $(this).parent().parent();
  var namespace = container.attr('data-space');
  var photo = EditDocForm.getMainPhoto(photoPrefix, namespace);

  if (photo.isExists) {
    return {imgId: photo.id + '?round=1&' + getRand()}
  } else {
    return {};
  }
}
