function(e, doc) {
  var params = $$(document).params;
  var h = $$(this).evently[params.view];

  if (h && h.helpers) {
    var helpers = $.evently.utils.evfun(h.helpers);
  }
  
  if (doc.extracts) {
    doc.extracts_raw = doc.extracts.join('\n\n')
  }

  function if_new() {
    return doc._id == undefined;
  }

  function if_not_new() {
    return !if_new();
  }

  var view = {
    doc: doc,
    if_new: if_new, 
    if_not_new: if_not_new
  }

  if (helpers) {
    view = $.extend(view, helpers(doc));
  }

  return view; 
}
