function() {
  var updater = new ImgUpdater(EditDocForm.doc(), 'cover_attachments');
  var el = $(this).find('.uploader');

  var uploader = new qq.FileUploader({
    element: el[0],
    multiple: false,
    action: updater,
    allowedExtensions: ['jpg', 'jpeg', 'png', 'gif'],
    onSubmit: function(id, fileName) { },
    onComplete: function(id, fileName, responseJSON) {
      if (responseJSON) {
        updater.uploadComplete(responseJSON, function(doc) {
          $('#edit_form').trigger('editPublication', doc);
        });
      }
    }
 });
}
