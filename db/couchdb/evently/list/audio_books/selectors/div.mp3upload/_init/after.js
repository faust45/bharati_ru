function() {
  var el = $(this).find('.uploader');
  var uploader = new Mp3Uploader();

  var uploader = new qq.FileUploader({
    element: el[0],
    multiple: true,
    action: uploader,
    onSubmit: function(id, fileName) { },
    onComplete: function(id, fileName, responseJSON) {
      if (responseJSON) {
      }
    }
 });
}
