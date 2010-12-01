function(cb, ev, doc) {
  if (doc.events) {
    App.app.db.allDocs({
      include_docs: true,
      keys: doc.events,
      success: function(resp) {
        cb(resp);
      }
    });
  } else {
    cb({});
  }
}
