function(e, ev, collection) {
  $.log('render page', collection);
  var maxPages = parseInt(collection.total) / 10;
  if (collection.total % 10) {
    maxPages = maxPages + 1;
  }

  return {pages: range(1, maxPages), link: collection.type};
}
