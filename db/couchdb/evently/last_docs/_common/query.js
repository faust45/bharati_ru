function(e, params) {
  var app = $$(this).app;
  var viewName = e.type + '_all';
  if (!app.ddoc.views[viewName]) {
    viewName = e.type;
  }

  params = params || {page: 1}
  page = params.page || 1;

  var offset = (page - 1) * 10;
  $$('#last_docs').page = page;

  return {
    "view": viewName,
    "skip": offset,
    "limit": 10,
    "reduce": false,
    "include_docs": true,
    "descending": true
  }
}
