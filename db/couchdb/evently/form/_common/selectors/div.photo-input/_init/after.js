function(e, doc, doc_updater) {
  var el = $(this).find('.uploader');
  var attr = $(this).attr('data-name');

  var updater = new PhotoUploader(doc, doc_updater, attr);

  var uploader = new qq.FileUploader({
    element: el[0],
    multiple: false,
    action: updater,
    allowedExtensions: ['jpg', 'jpeg', 'png', 'gif'],
    onSubmit: function(id, fileName) { },
    onComplete: function(id, fileName, responseJSON) {
      if (responseJSON) {
        updater.updateOwner(responseJSON);
      }
    }
 });
}
