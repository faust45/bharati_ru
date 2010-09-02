$(document).ready(function() { 
  $('div.mp3_attachment').behavior(Mp3Attachment); 
});

function Mp3Attachment(element, config) {
  element = $(element);

  var input = element.find('input[type=file]');
  var linkToDownload = element.find('a.download');
  var urlToReplace = input.attr('data-replace-url');
  var containerDiv = input.parent();
  var control = buildControlDiv();

  control.linkToUpload.click(function(el) {
    input.uploadifySettings('scriptData', {need_update_info: control.isNeedUpdateInfo()});
    input.uploadifyUpload();

    return false;
  });

   containerDiv.append(control);
   control.hide();

   input.uploadify({
    uploader:  '/uploadify.swf', 
    script:    urlToReplace, 
    folder:    '/path/to/uploads-folder', 
    cancelImg: '/images/cancel.png',
    multi:     false,
    auto:      false,
    width: 150,
    height: 50,
    buttonImg: '/images/replace.png',
    buttonText: '',
    fileExt: '*.mp3',
    fileDesc: 'Only *.mp3 allow',
    onSelect: function(event, queueID, fileObj) {
      control.checkBox.attr('checked', false);
      control.show();
    },
    onCancel: function(event, queueID, fileObj) {
      control.hide();
    },
    onComplete: function(event, queueID, fileObj, response, data) {
      var resp = eval('(' + response + ')');
      control.hide();
      linkToDownload.attr('href', resp.url);
      linkToDownload.html(resp.file_name);
      linkToDownload.effect("highlight", {}, 10000);
    },
    onProgress: function(event, queueID, fileObj, data) {
    }
  }); 
}



function buildControlDiv() {
  var newDiv = $("<div />");
  var checkBox = $("<input type='checkbox' />");
  var label = $("<label />");
  var linkToUpload = $("<a href='#'>Залить</a>");

  label.append(checkBox);
  label.append("зменить теги");
  newDiv.append(label);
  newDiv.append("&nbsp;&nbsp;");
  newDiv.append(linkToUpload);

  newDiv.linkToUpload = linkToUpload;
  newDiv.isNeedUpdateInfo = function() {
    return checkBox.is(':checked'); 
  };

  newDiv.checkBox = checkBox; 

  return newDiv; 
}



