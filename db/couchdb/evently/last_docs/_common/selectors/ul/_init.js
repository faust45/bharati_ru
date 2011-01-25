function(e) {
  $(this).find('li').draggable({
    helper:'clone',
    scope: 'sub-albums',
    cursor: 'move',
    opacity: 100,
    appendTo: '.wrap',
    zIndex:  20000 
  });

}
