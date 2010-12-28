function() {
  var db = App.app.db;
  var self = $(this);

  db.saveDoc(form2json(this), {
    success: function(resp) {
      $('#edit_form').trigger('event_album');
    }
  });

  return false;
}
