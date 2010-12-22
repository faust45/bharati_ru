function() {
  var li = $(this),
      id = li.attr('data-id');

  $(this).draggable({
    scope: 'item-box',
  });
  return;
    
  $.log('init li.photo', li);
  li.bind('dragstart', function(e) {
    $.log('start drag');
    e.originalEvent.dataTransfer.setData('text/plain', id);
    e.originalEvent.dataTransfer.setData('text/html', li);
    return true;
  });
}
