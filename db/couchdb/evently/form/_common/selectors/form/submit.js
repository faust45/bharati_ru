function(e, a) {
  var db = App.app.db;
  var self = $(this);

  $.log(e, a);
  $.log(form2json(this));
  return false;
  db.saveDoc(form2json(this), {
    success: function(resp) {
      $('#edit_form').trigger('event_album');
    }
  });

  return false;
}
