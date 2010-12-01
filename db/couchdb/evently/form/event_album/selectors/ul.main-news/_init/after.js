function() {
  var el = $(this);

 function append(ul, el) {
    var id = el.attr('data-id');
    var title = el.find('a').html();

    var html = "<li><img src='images/arrow.png' /><input type='hidden' name='news[]' value=" + id + ">" + title + "</li>"
    ul.append(html);
  }

  el.droppable({
    hoverClass: 'dropHere',
    drop: function(event, ui) {
      var li = ui.draggable;
      $.log(li);
      if (!li.parent().hasClass('main-news')) {
        append($(this), li);
      }
    }
  });

  el.find('li').draggable({
    helper:'clone'
  });
}
