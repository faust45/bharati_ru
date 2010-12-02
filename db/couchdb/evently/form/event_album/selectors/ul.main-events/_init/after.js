function() {
  var el = $(this);

  function append(ul, item) {
    var id = item.attr('data-id');
    var title = item.find('a').html();

    var html = "<li><img src='images/arrow.png' /><input type='hidden' name='events[]' value=" + id + ">" + title + "</li>"
    ul.append(html);
  }

  el.droppable({
    hoverClass: 'dropHere',
    drop: function(event, ui) {
      var li = ui.draggable;
      if (!li.parent().hasClass('main-events')) {
        append($(this), li);
      }
    }
  });

  el.find('li').draggable({
    helper:'clone'
  });
}