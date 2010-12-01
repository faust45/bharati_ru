function() {
  var el = $(this);

  el.find('ul').sortable({
    update: function(event, ui) { 
      el.trigger('formChanged');
    }
  });
}
