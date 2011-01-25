function(cb, e, doc) {
  var collection = doc.tracks;

  if (collection) {
    App.app.db.allDocs({
      include_docs: true,
      keys: collection,
      success: function(resp) {
        cb.apply(this, [resp]);
      }
    });
  } else {
    $(this).find('ul').html('');
  }
}
