function(args) {
  var self = $(this);
  var fields = this.fields;
  var data = {};

  $.each(fields, function(el) {
    var attr = $(this).attr('name');
    data[attr] = this.ctl.getData(); 
  });
  data['couchrest-type'] = $(this).attr('data-type');
  data['_id'] = data['_id'] || new Date().toCouchId();

  $.log('in send data', fields, data);
  $$(this).app.db.saveDoc(data, {
    success: function(resp) {
      self.trigger('formSaved');
    }
  });

  return false;
}
