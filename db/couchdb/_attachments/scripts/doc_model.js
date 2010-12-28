DocModel = function(id, options) {
  options = options || {};
  var doc, onloadColbacks = [];

  onload(options.onload);

  if (id != 'new') {
    loadDoc();
  } else {
    doc = {};
    $.log('in new doc', doc);
    runCallbacks();
  }
  
  function loadDoc() {
    var url = 'http://192.168.1.100:5984' + DocsStore.uri + id;

    DocsStore.openDoc(id, {
      success: function(data) {
        doc = data;
        runCallbacks();
      },
      error: function(res, textStatus, reason) {
        $.log(res, textStatus, reason);
        if (reason == 'not_found') {
          doc = {};
          runCallbacks();
        }
      }
    });
  }

  function addToAlbum(attr, ids) {
    var isChanged = false;

    if (!doc[attr]) {
      doc[attr] = [];
    }

    var album = doc[attr];

    for(var i in ids) {
      var id = ids[i];

      if (album.indexOf(id) == -1) {
        album.push(id);
        isChanged = true;
      }
    };

    isChanged && save();
  }

  function update(form, d) {
    var data = d || form2json(form), isChanged = false;

    $.each(data, function(key, value) {
      if (doc[key] != value) {
        isChanged = true;
      }
      doc[key] = value;
    });

    if (!doc._id) {
      doc._id = (new Date()).toCouchId();
    }

    isChanged && save();
  }

  function save() {
    DocsStore.saveDoc(doc, {
      success: function(resp) { id = resp.id; loadDoc(); }
    });
  }

  function onload(cb) {
    if (typeof cb == 'function') {
      onloadColbacks.push(cb);
    }
  }

  function runCallbacks() {
    onloadColbacks.forEach(function(cb) {
      cb(doc, update, addToAlbum, loadDoc);
    })
  }

  return {
    onload: onload,
    update: update,
    save: save
  }
}
