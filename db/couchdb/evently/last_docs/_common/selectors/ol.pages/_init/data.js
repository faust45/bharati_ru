function(e, data, ev, params) {
  $.log('render page', params);
  var total = data.total_rows;
  var maxPages = parseInt(total) / 10;
  if (total % 10) {
    maxPages = maxPages + 1;
  }

  return {pages: range(1, maxPages), link: params.view};
}
