function() {
  var page = $$('#last_docs').page;
  $(this).find('li[data-num=' + page + '] a').addClass('active');
}
