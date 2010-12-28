function(e, doc) {
  var params = $$(document).params;
  $('#sub_list').trigger(params.form, [doc]);
}
