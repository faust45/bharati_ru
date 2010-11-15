function() {
  var photoType = $(this).attr('data-photo') || "vertical";
  var updater = EditDocForm.getMainPhoto(photoType);
  var el = $(this).find('.uploader');

  var uploader = new qq.FileUploader({
    element: el[0],
    multiple: false,
    action: updater,
    allowedExtensions: ['jpg', 'jpeg', 'png', 'gif'],
    onSubmit: function(id, fileName) { },
    onComplete: function(id, fileName, responseJSON) {
      if (responseJSON) {
        updater.onUploadComplete(responseJSON, function(doc) {
          $('#edit_form').trigger('editPublication', doc);
        });
      }
    }
 });
}
