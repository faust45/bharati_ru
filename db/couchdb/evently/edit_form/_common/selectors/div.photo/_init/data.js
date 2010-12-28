function(e, doc) {
  var attr = $(this).attr('data-field') || $(this).prev().attr('data-field');
  photoId = doc[attr || "main_photo"];

  $.log(attr, $(this).prev());

  if (photoId) {
    return {imgId: photoId + '?round=1&' + getRand()}
  } else {
    return {};
  }
}
