function(cb, e, ev, doc) {
  var el = $(this),
      attr = el.attr('data-name'),
      collection = doc[attr];

  if (collection) {
    App.app.db.allDocs({
      include_docs: true,
      keys: collection,
      success: function(resp) {
        cb(resp, attr);
      }
    });
  } else {
    cb({});
  }
}
