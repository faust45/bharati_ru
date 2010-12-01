function(cb, ev, doc) {
  if (doc.news) {
    App.app.db.allDocs({
      include_docs: true,
      keys: doc.news,
      success: function(resp) {
        cb(resp);
      }
    });
  } else {
    cb({});
  }
}
