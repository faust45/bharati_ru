function(cb, form) {
  $.log('Faq');
  var app = $$(this).app;

  if (!MyApp.authors) {
    app.db.view('global/authors_all', {reduce: false, include_docs: true,
      success: function(resp) {
        MyApp.authors = resp;
        cb(resp);
      }
    });
  } else {
    cb(MyApp.authors);
  }
}
