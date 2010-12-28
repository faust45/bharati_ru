function(cb, e, doc) {
  var collection = doc.tracks;

  App.app.db.allDocs({
    include_docs: true,
    keys: collection,
    success: function(resp) {
      cb.apply(this, [resp]);
    }
  });
}
