function(cb, ev, id) {
  var id = id || $(ev.target).attr('data-id');
  var model = new DocModel(id, {onload: cb});
}
