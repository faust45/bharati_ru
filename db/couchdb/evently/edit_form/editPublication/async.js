function(cb, ev, li) {
  if (li._rev) {
    var doc = li;
    EditDocForm.currentDoc = doc; 
    cb(doc);
  } else {
    var id = $(li).attr('data-id');
    var app = $$(this).app;
    app.db.openDoc(id, {
      success: function(doc) {
        EditDocForm.currentDoc = doc; 
        cb(doc);
      }
    });
  }
}

