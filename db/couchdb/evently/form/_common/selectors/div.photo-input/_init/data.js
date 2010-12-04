function(e, doc) {
  var attr = $(this).attr('data-name');
  photoId = doc[attr || "main_photo"];

  if (photoId) {
    return {imgId: photoId + '?round=1&' + getRand()}
  } else {
    return {};
  }
}
