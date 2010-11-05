function(args) {
  var self = $(this);
  var fields = $$(this).formEdit.fields;
  var data = {};

  $.each(fields, function(el) {
    var attr = $(this).attr('name');
    data[attr] = this.ctl.getData(); 
  });

  data['couchrest-type'] = 'Author';
  $$(this).app.db.saveDoc(data, {
    success: function(resp) {
      self.trigger('formSaved');
    }
  });

  return false;
}
