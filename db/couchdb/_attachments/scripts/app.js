MyApp = {
  init: function() {
  }
}

EditDocForm = {
  currentDoc: null,

  docId: function() {
    return this.currentDoc._id;
  },

  setDoc: function(doc) {
    this.currentDoc = doc;
  },

  setCouchrestTypeIfBlank: function(value) {
    this.couchrestType = value;
  },

  doc: function() {
    return this.currentDoc;
  },

  setMainPhotoId: function(id) {
    this.currentDoc.main_photo = id;
  },

  getMainPhotoId: function() {
    return this.currentDoc.main_photo;
  },

  update_attr: function(attr, value) {
    var doc = this.currentDoc;
    doc[attr] = value;
  },

  update: function(hash) {
    var doc = this.currentDoc;

    $.each(hash, function(k, v) {
      doc[k] = v;
    });
  },

  openDoc: function(id, cb) {
    DocsStore.openDoc(id, {
      success: function(doc) {
        EditDocForm.setDoc(doc); 
        cb(doc);
      }
    });
  },

  beforeValidate: function() {
    if (isBlank(this.currentDoc['couchrest-type'])) {
      this.currentDoc['couchrest-type'] = this.CouchrestType;
    }
  },

  validate: function() {
    if (!isBlank(this.currentDoc['couchrest-type'])) {
      return true;
    } else {
      alert('Try save doc missing couchrest-type');
      return false;
    }
  },

  save: function(cb) {
    this.beforeValidate();

    if (this.validate()) {
      DocsStore.saveDoc(this.currentDoc, { success: cb });
    }
  }
}


ImgUpdater = function(source, attr) {
  var imgId = source.getMainPhotoId();

  function updateOwner(resp, cb) {
    if(!imgId) {
      source.setMainPhotoId(resp.id);
      source.save(cb);
    } else {
      cb(source.doc());
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
    },

    uploadComplete: function(resp, cb) {
      updateOwner(resp, cb);
    }
  }
}

DocsStore = $.couch.db('rocks');
FileStore = $.couch.db('rocks_file_store');

$(document).ready(function() {
  //$.ajaxSetup({transport:'flXHRproxy'});
  //$.flXHRproxy.registerOptions("http://127.0.0.1/",{xmlResponseText:false});

  //$.post( 'http://127.0.0.1/upload', {});
});



$.fn.tabs = function() {
  var tabs = $('form').find('div.cnt');
  var ul = $(this).find('li');

  ul.each(function(i) {
    var li = $(this);

    li.click(function() {
      ul.removeClass('active');
      li.addClass('active');
      tabs.removeClass('active');
      $(tabs[i]).addClass('active');
      return false;
    })
  });
}
