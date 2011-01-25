function(e, ev, doc, update, addToAlbum, reload) {
  var el = $(this), data = {};
  var type     = el.attr('data-type'),
      toAlbum  = el.attr('data-bind-to-album'),
      field = el.attr('data-field'),
      fileName = el.attr('data-filename'),
      saveFullName = el.attr('data-save-full-name'),
      db = el.attr('data-db');

  db = (db == "docs") ? DocsStore : FileStore;

  var id;
  if (field && doc[field]) {
    id = doc[field];
    if ('object' == typeof id) {
      id = id.doc_id
    }
  }

  var uploadIds = [];
  var options = {
    id: id,
    db: db,
    type: type,
    success: success,
    queryEmpty: queryEmpty
  };

  if (fileName == 'native') {
    options.nativeName = true;
  }

  el.asUpload(options);

  function queryEmpty() {
    el.trigger('after_upload_all', [uploadIds, reload]);

    if (toAlbum) {
      addToAlbum(toAlbum, uploadIds);
    }
  }

  function success(resp, fileName, url) {
    uploadIds.push(resp.id);
    el.trigger('after_upload_each', [doc, resp, fileName, url]);

    if (type) {
      dbUpdate(db, 'global', 'assign_type', resp.id, {type: type}, function() { });
    }

    if (field) {
      if (saveFullName) {
        data[field] = {doc_id: resp.id, file_name: fileName};
        update(null, data);
      } else {
        data[field] = resp.id;
        update(null, data);
      }
    }
  }
}
