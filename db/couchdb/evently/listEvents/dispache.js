function(e, params) {
  var events = $$('#last_docs').evently;
  $.log('in dispage', params);

  if (params.form) {
    $('#edit_form').trigger(params.form, params.id);
    $('#last_docs').trigger('currentChanged', params.id);
  } else if (events[params.view]) { 
    $('#last_docs').trigger(params.view, params);
  } else {
    $('#last_docs').trigger('default', params);
  }
}
