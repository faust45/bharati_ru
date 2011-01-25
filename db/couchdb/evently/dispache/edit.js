function(e, params) {
  $$(document).params = params;
  var lastDocs = $$('#last_docs').evently,
      subList   = $$('#sub_list').evently;

  var subView = subList[params.view] ? params.view : "blank";

  function onDocLoad() {
    $('#last_docs').trigger('currentChanged', params.id);
    $('#sub_list').trigger(subView, arguments);
    $('#edit_form').trigger(params.view, arguments);
  }

  new DocModel(params.id, {onload: onDocLoad});
}
