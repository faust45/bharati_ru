function(e, page) {
  page = (page || 1);
  var offset = (page - 1) * 10;
  $$('#last_docs').page = page;

  return {
    "view": "publications_all",
    "skip": offset,
    "limit": 10,
    "reduce": false,
    "include_docs": true
  }
}
