function() {
  var el = $(this);
  var type = el.attr('data-type');
  $.log($$(this).evently);

  el.asUpload({
    success: function(resp) {
      dbUpdate(App.app, 'assign_type', resp.id, {type: type}, function() { })
    }
  });
}
