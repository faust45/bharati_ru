function(resp) {
  var total = resp.rows[0].value;
  var maxPages = parseInt(total) / 10;
  if (total % 10) {
    maxPages = maxPages + 1;
  }

  return {pages: range(1, maxPages)};
}
