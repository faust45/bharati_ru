function(e) {
  var page = $(this).attr('data-num');
  $('#last_docs').trigger('authors', page);
  return false;
}
