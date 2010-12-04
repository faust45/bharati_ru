function() {
  $.log('in drob init trash');
  return {
    hoverClass: 'dropHere',
    drop: function(event, ui) {
      var li = ui.draggable;
      $.log('in trash', el, li, ui);
      li.html('');
    }
  };
}
