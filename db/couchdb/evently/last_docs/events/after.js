function(e) {
  $.log('create drag');
  $(this).find('ul li').draggable({
    helper:'clone'
  });
}
