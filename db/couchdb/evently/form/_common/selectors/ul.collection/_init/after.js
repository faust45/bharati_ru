function(e) {
  var el = $(this);
  var attr = el.attr('data-name');

  function append(li) {
    var id = li.attr('data-id');
    var title = li.find('a').html();

    var html = "<li><img src='images/arrow.png' /><input type='hidden' name='" + attr + "[]' value=" + id + ">" + title + "</li>"
    el.append(html);
  }

  
  el.droppable({
    hoverClass: 'dropHere',
    accept: 'li.item',
    drop: function(event, ui) {
      var li = ui.draggable;
      append(li);
    }
  });

  el.sortable({
    containment: 'document',
    items: 'li',
    dropOnEmpty: true,
    out: function(event, ui) { $.log('out') },
    remove: function(event, ui) { },
    over: function(event, ui) { $.log('over in') },
    receive: function(event, ui) { $.log('recive in') },
    helper:'clone',
    cursor: 'move',
    opacity: 100,
    appendTo: '.wrap',
    zIndex:  20000,
    connectWith: '#trash',

    update: function(event, ui) { 
      el.trigger('formChanged');
    }
  });


}
