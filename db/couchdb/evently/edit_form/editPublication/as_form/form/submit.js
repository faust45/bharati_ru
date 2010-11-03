function(args) {
  var self = $(this);
  var fields = $$(this).formEdit.fields;
  var data = {};

  $.each(fields, function(el) {
    var attr = $(this).attr('name');
    data[attr] = this.ctl.getData(); 
  });

  var doc = $.extend(false,  EditDocForm.currentDoc, data);
  $$(this).app.db.saveDoc(doc, {
    success: function(resp) {
      self.trigger('formSaved');
    }
  });

  return false;
}
