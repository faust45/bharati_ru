function() {
  var photoPrefix = $(this).attr('data-photo');
  var el = $(this).find('.uploader');
  var container = $(this).parent().parent();
  var namespace = container.attr('data-space');

  var updater = EditDocForm.getMainPhoto(photoPrefix, namespace);

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
