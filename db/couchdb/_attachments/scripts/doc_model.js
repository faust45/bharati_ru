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

  function update(form) {
    var data = form2json(form);
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
