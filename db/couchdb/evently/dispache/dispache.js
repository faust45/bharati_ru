function(e, params, a) {
  $.log('in dispatch: ', e, params, a);
  $$(document).params = params;
  var events = $$('#last_docs').evently;

  if (params.form) {
    $('#edit_form').trigger(params.form, params.id);
    $('#last_docs').trigger('currentChanged', params.id);
  } else if (events[params.view]) {
    $('#top_menu').trigger(params.view);
    $('#last_docs').trigger(params.view, params);
  } else {
    $('#top_menu').trigger(params.view);
    $('#last_docs').trigger('default', params);
  }
}
