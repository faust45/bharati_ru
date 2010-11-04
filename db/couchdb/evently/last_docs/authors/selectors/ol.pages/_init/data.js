function(resp) {
  var total = resp.rows[0].value;
  var maxPages = parseInt(total) / 10;
  if (total % 10) {
    maxPages = maxPages + 1;
  }
  $.log('$$(this).page');
  $.log($$('#last_docs').page);

  return {pages: range(1, maxPages)};
}
