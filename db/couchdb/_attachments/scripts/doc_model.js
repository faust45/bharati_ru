DocModel = function(id) {
  var doc, onloadColbacks = [];

  loadDoc(id);
  
  function loadDoc() {
    DocsStore.openDoc(id, {
      success: function(openDoc) {
        doc = openDoc;
        onloadColbacks.forEach(function(cb) {
          cb(doc, update);
        })
      }
    });
  }

  function update(form, d) {
    var data = d || form2json(form);
    $.log('in doc update', data);
    $.each(data, function(key, value) {
      if (key != '_rev' && key != '_id') {
        doc[key] = value;
      }
    });

    save();
  }

  function save() {
    DocsStore.saveDoc(doc, {
      success: function(resp) { loadDoc(); }
    });
  }

  function onload(cb) {
    onloadColbacks.push(cb);
  }

  return {
    onload: onload,
    update: update,
    save: save
  }
}


PhotoUploader = function(doc, updater, attr) {
  attr = attr || 'main_photo';
  var photoExists = !!doc[attr];

  function url(name, cb) {
    photoExists ? updatePhoto(cb) : createPhoto(cb);
  }

  function createPhoto(cb) {
    var path = FileStore.uri + $.couch.newUUID() + '/' + 'img';
    cb(path);
  }

  function updatePhoto(cb) {
    var photoId = doc[attr];

    FileStore.openDoc(photoId, {
      success: function(photoDoc) {
        var path = FileStore.uri + photoId + '/' + 'img?rev=' + photoDoc._rev;
        cb(path);
      }
    });
  }

  function updateOwner(resp) {
    var data = {};
    data[attr] = resp.id; 
    updater(null, data);
  }

  return {
    url: url,
    updateOwner: updateOwner
  }
}
