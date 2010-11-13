function(args) {
  var self = $(this);
  var fields = this.fields;
  var data = {};

  $.each(fields, function(el) {
    var attr = $(this).attr('name');
    data[attr] = this.ctl.getData();
  });

  $.log('in send data', fields, data);

  EditDocForm.update(data);
  EditDocForm.setCouchrestTypeIfBlank($(this).attr('data-type'));

  EditDocForm.save(function(resp) {
    self.trigger('formSaved');
  });

  return false;
}
