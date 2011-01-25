function(e, params) {
  $$(document).params = params;
  var lastDocs = $$('#last_docs').evently;

  function onDocLoad() {
    $('#sub_list').trigger('currentChanged', params.id);
    $('#edit_form').trigger(params.view + '_' + params.sub_view, arguments);
  }

  new DocModel(params.id, {onload: onDocLoad});
}
