function(e, doc, update, addToAlbum, reload) {
  var el = $(this), data = {};
  var type     = el.attr('data-type'),
      toAlbum  = el.attr('data-bind-to-album'),
      field = el.attr('data-field'),
      db = el.attr('data-db');

  db = (db == "docs") ? DocsStore : FileStore;

  var uploadIds = [];
  var options = {
    id: doc[field],
    db: db,
    success: success,
    queryEmpty: queryEmpty
  };

  el.asUpload(options);

  function queryEmpty() {
    if (toAlbum) {
      addToAlbum(toAlbum, uploadIds);
    }
  }

  function success(resp) {
    uploadIds.push(resp.id);

    if (type) {
      dbUpdate(App.app, 'assign_type', resp.id, {type: type}, function() { });
    }

    if (field) {
      data[field] = resp.id;
      update(null, data);
    }
  }
}
