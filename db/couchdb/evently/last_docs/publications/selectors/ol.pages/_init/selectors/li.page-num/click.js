function(e) {
  var page = $(this).attr('data-num');
  $('#last_docs').trigger('publications', page);
  return false;
}
