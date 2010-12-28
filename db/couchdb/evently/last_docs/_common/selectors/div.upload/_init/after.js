function(e, data, ev, params) {
  var el = $(this),
      type     = el.attr('data-type'),
      fileName = el.attr('data-filename'),
      options  = $$('#last_docs').evently[params.view],
      db = el.attr('data-db'),
      db = (db == "docs") ? DocsStore : FileStore,

      uploadOptions = {
        db: db,
        success: function(resp, fileName, url) {
          if (type) {
            dbUpdate(FileStore, 'global', 'assign_type', resp.id, {type: type}, function() {});
          }

          try {
            options.after_upload && $.evently.utils.rfun(this, options.after_upload, [resp, fileName, url]);
          } catch(e) {
            $.log('Catch error: ', e);
          }
        }
      };

  if (fileName == 'native') {
    uploadOptions.nativeName = true;
  }

  el.asUpload(uploadOptions);
}
