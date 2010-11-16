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

  docIsUnread: function() {
    return !this.doc().is_read;
  },

  markAsRead: function(cb) {
    this.update_attr('is_read', true);
    this.save(cb);
  },

  getMainPhoto: function(type) {
    var source = this, doc = this.doc();
    var attr = !isBlank(type) ? 'main_photo_' + type : 'main_photo';
    var id = doc[attr],
        isExists = id;
                  
    function path() {
      var id = !isExists ? $.couch.newUUID() : doc[attr];
      return FileStore.uri + id + '/' + 'img' + '?';
    }

    function url(fileName, upload) {
      if (isExists) {
        FileStore.openDoc(id, {
          success: function(imgDoc) {
            upload(path() + qq.obj2url({rev: imgDoc._rev}));
          }
        });
      } else {
        upload(path());
      }
    }

    function update(resp, cb) {
      if (!isExists) {
        source.update_attr(attr, resp.id)
        source.save(cb);
      } else {
        cb(doc);
      }
    }

    return {
      url: url,
      onUploadComplete: update,
      id: id,
      isExists: isExists
    }
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
