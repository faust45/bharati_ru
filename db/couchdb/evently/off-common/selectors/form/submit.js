function(args) {
  var self = $(this);
  var fields = this.fields;
  var data = {};

  $.each(fields, function(el) {
    var attr = $(this).attr('name');
    var container = $(this).parent().parent();
    var namespace = container.attr('data-space'); 

    EditDocForm.update_attr(namespace, attr, this.ctl.getData());
  });
  EditDocForm.setCouchrestTypeIfBlank($(this).attr('data-type'));

  $.log(EditDocForm.doc());

  EditDocForm.save(function(resp) {
    self.trigger('formSaved');
  });

  return false;
}
