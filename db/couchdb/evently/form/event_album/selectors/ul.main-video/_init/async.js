function(cb, ev, doc) {
  if (doc.videos) {
    App.app.db.allDocs({
      include_docs: true,
      keys: doc.videos,
      success: function(resp) {
        cb(resp);
      }
    });
  } else {
    cb({});
  }
}
