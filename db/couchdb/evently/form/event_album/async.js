function(cb, ev, li) {
  function fetchEvents(doc) {
    App.app.db.allDocs({
      include_docs: true,
      keys: doc.events,
      success: function(resp) {
        cb(doc, resp);
      }
    });
  }

  App.app.db.openDoc('events_main_album', {success: fetchEvents});
}
