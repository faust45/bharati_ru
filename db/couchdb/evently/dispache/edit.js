function(e, params) {
  $$(document).params = params;
  var lastDocs = $$('#last_docs').evently,
      subList  = $$('#sub_list').evently;

  var viewForm = toViewName(params.view);
  var subView = subList[viewForm] ? viewForm : "blank";

  function onDocLoad() {
    $('#last_docs').trigger('currentChanged', params.id);
    $('#sub_list').trigger(subView, arguments);
    $('#edit_form').trigger(viewForm, arguments);
  }

  var id = params.id,
      currPath = $.pathbinder.currentPath().toString();

  if (!id && currPath.match(/http.*$/)) {
    id = currPath.match(/http.*$/)[0];
  } 

  new DocModel(id, {onload: onDocLoad});
}
