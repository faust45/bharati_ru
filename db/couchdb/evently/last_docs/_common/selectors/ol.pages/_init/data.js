function(e, data, a) {
  var type = a.type;
  var total = data.total_rows;
  var maxPages = parseInt(total) / 10;
  if (total % 10) {
    maxPages = maxPages + 1;
  }

  return {pages: range(1, maxPages), link: type};
}
