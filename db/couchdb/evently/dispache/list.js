function(e, params) {
  $$(document).params = params;
  var lastDocs = $$('#last_docs').evently;
  var view = lastDocs[params.view] ? params.view : "default";

  var page = params.page || 1;
  $$('#last_docs').page = page;

  function onLoad() {
    $('#top_menu').trigger(view);
    $('#last_docs').trigger(view, arguments);
    $('#sub_list').trigger('blank');
  }

  new DocCollection(params.view, {onload: onLoad, page: page});
}
