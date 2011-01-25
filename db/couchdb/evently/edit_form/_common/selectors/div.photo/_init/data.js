function(e, ev, doc) {
  var attr = $(this).attr('data-field') || $(this).prev().attr('data-field');
  photoId = doc[attr || "main_photo"];

  if (photoId) {
    return {imgId: photoId + '?round=1&' + getRand()}
  } else {
    return {};
  }
}
