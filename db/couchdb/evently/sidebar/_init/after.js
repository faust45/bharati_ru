function() {
  $(this).find('#trash').sortable({
    dropOnEmpty: true,
    receive: function(event, ui) { ui.item.remove() },
  });
}
