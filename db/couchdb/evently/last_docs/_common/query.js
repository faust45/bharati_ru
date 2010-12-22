function(e, params) {
  var app = $$(this).app;
  var viewName = params.view;
  if (!app.ddoc.views[viewName]) {
    viewName = viewName + '_all';
  }

  if (!app.ddoc.views[viewName]) {
    alert('Error: could not detect view ' + viewName);
  }

  params = params || {};
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
