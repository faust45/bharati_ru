MyApp = {
  init: function() {
  }
}

EditDocForm = {
  currentDoc: null,

  docId: function() {
    return this.currentDoc._id;
  },

  doc: function() {
    return this.currentDoc;
  }

}

ImgUpdater = function(doc, attr) {
  var imgId; 
  if(!isBlank(doc[attr])) {
    imgId = doc[attr][0]; 
  }

  function updateOwner(resp, cb) {
    if(!imgId) {
      doc[attr] = [resp.id];
      DocsStore.saveDoc(doc, {
        success: function(newDoc) {
          cb(doc);
        }
      });
    } else {
      cb(doc);
    }
  }

  return {
    url: function(fileName, cb) {
      var id = !imgId ? $.couch.newUUID() : imgId;
      var p = FileStore.uri + id + '/' + 'img' + '?';

      if (imgId) {
        FileStore.openDoc(imgId, {
          success: function(imgDoc) {
            cb(p + qq.obj2url({rev: imgDoc._rev}));
          }
        });
      } else {
        cb(p);
      }

      return p;
    },

    uploadComplete: function(resp, cb) {
      updateOwner(resp, cb);
    }
  }
}

DocsStore = $.couch.db('rocks_dev');
FileStore = $.couch.db('rocks_file_store_dev');

$(document).ready(function() {
  //$.ajaxSetup({transport:'flXHRproxy'});
  //$.flXHRproxy.registerOptions("http://127.0.0.1/",{xmlResponseText:false});

  //$.post( 'http://127.0.0.1/upload', {});
});
