function(cb, ev, params) {
  var id = params.id;
  var model = new DocModel(id);
  model.onload(cb);
}

