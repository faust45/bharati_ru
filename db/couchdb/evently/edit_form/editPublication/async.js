function(cb, ev, li) {
  var id = $(li).attr('data-id');

  var app = $$(this).app;
  app.db.openDoc(id, {
    success: function(doc) {
      EditDocForm.currentDoc = doc; 
      cb(doc);
    }
  });
}

