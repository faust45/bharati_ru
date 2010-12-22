function() {
  var li = $(this),
  id = li.attr('data-id');
    
  li.bind('dragstart', function(e) {
    e.originalEvent.dataTransfer.setData('text/plain', id);
    return true;
  });
}
