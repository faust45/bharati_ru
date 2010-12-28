function(e, doc, update, addToAlbum, reload) {
  var el = $(this), data = {};
  var type     = el.attr('data-type'),
      toAlbum  = el.attr('data-bind-to-album'),
      field = el.attr('data-field'),
      fileName = el.attr('data-filename'),
      db = el.attr('data-db');

  db = (db == "docs") ? DocsStore : FileStore;

  var uploadIds = [];
  var options = {
    id: doc[field],
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
    el.trigger('after_upload_all', uploadIds);

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
      data[field] = resp.id;
      update(null, data);
    }
  }
}
