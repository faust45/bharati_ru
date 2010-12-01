function() {
  var el = $(this);
  $.log('after _init sidebar', el);

  el.droppable({
    hoverClass: 'dropHere',
    drop: function(event, ui) {
      var li = ui.draggable;
      $.log('in trash', el, li, ui);
      li.html('');
    }
  });
}
