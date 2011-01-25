function(e, params) {
  $$(document).params = params;
  var lastDocs = $$('#last_docs').evently;
  var view = lastDocs[params.view] ? params.view : "default";

  $('#top_menu').trigger(view);
  $('#last_docs').trigger(view, params);
  $('#sub_list').trigger('blank');
}
