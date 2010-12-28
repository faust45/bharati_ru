FileUploader = function(dropzone, options) {
  new View();
  var db = options.db || FileStore,
      uploadQuery = {}, count = 0;


  function upload(myFile, itemUI) {
    var xhr = new XMLHttpRequest(),
        id = options.id;

    xhr.upload.onprogress  = onprogress;
    xhr.onreadystatechange = onreadystatechange; 

    addToQuery(myFile);

    if (id) {
      db.openDoc(id, {
        success: function(doc) { run(doc._rev); }
      });
    } else {
      id = $.couch.newUUID();
      run();
    }

    function run(rev) {
      var url = path();
      if(rev) url = url + 'rev=' + rev;

      xhr.open("PUT", url, true);
      xhr.setRequestHeader("Content-Type", Mime.type(myFile.fileName));
      xhr.send(myFile);
    }

    function onprogress(e) {
      if (e.lengthComputable) {
        var percentage = Math.round((e.loaded * 100) / e.total);
        itemUI.progress(percentage);
      }
    }
  
    function onComplete() {
      var response; 

      if (xhr.status == 201 || xhr.status == 200) {
        itemUI.success();
        delFromQuery(myFile);

        try { response = eval("(" + xhr.responseText + ")"); }
        catch(err) { response = {}; }

        options.success && options.success(response, fileName(), path());
        isUploadQueryEmpty() && options.queryEmpty && options.queryEmpty();
      }
    }
  
    function onreadystatechange() {
      if (xhr.readyState == 4) { onComplete(); }
    }

    function addToQuery() {
      uploadQuery[myFile] = true; count++;
    }

    function delFromQuery() {
      delete uploadQuery[myFile]; 
      if (0 < count) count--;
    }

    function isUploadQueryEmpty() {
      return count == 0;
    }

    function path() {
      return 'http://192.168.1.100:5984' + db.uri + id + '/' + fileName() + '?';
    }

    function fileName() {
      return (options.nativeName ? escape(myFile.fileName) : 'img')
    }
  }

  //----------------------------------------------------------------------------------------------------------------------
  function View() {
    var button      = $('<button class="awesome">Upload</button>'),
        fileInput   = $('<input type="file">'),
        filesList   = $('<ul class="file-upload-list"></ul>');


    function addItem(file) {
      var progressBar = $('<strong>0%</strong>'),
          li = $(r('<li>{{fileName}} {{size}} / </li>')).append(progressBar);

      filesList.append(li);

      upload(file, {
        progress: progress,
        success: success 
      });

      function progress(text) {
        progressBar.html(text + '%');
      }

      function success() {
        li.effect('highlight', {}, 3000);
        li.fadeOut('slow', function() { li.remove() });
      }

      function r(str) {
        return str
            .replace('{{fileName}}', file.fileName)
            .replace('{{size}}', formatSize(file.size));
      }
    }

    function formatSize(size) {
      var bytesPerMB = 1024 * 1024,
          mb = size / bytesPerMB;

      return Math.round(mb * 100) / 100 + ' MB';
    }


    dropzone
        .addClass('file-upload')
        .append(button)
        .append(fileInput)
        .append(filesList);
        
    button.click(function(e) {
      fileInput.trigger('click'); e.preventDefault();
    });

    dropzone.bind("dragover", function(e) {
      dropzone.addClass('file-upload-dragover'); e.preventDefault();
    }, true);
    dropzone.bind("dragleave", function(e) {
      dropzone.removeClass('file-upload-dragover'); e.preventDefault();
    }, true);
    dropzone.bind("drop", function(e) {
      var files = e.originalEvent.dataTransfer.files;
      dropzone.removeClass('file-upload-dragover');

      $.doWithEach(files, addItem);
      e.preventDefault();
    }, true);
  }
}


$.fn.asUpload = function(options) {
  new FileUploader(this, options);
}
