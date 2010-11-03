function() {
  var updater = new ImgUpdater(EditDocForm.doc(), 'cover_attachments');

  var uploader = new qq.FileUploader({
    element: this[0],
    multiple: false,
    allowedExtensions: ['jpg', 'jpeg', 'png', 'gif'],
    onSubmit: function(id, fileName) {
      uploader.setParams({ action: updater.url(fileName) });
    },
    onComplete: function(id, fileName, responseJSON) {
      if (responseJSON) {
        updater.uploadComplete(responseJSON);
      }
    }
 });
}
