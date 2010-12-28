function(cb, e, b) {
  var id = $(e.target).attr('data-id');
  var model = new DocModel(id, {onload: cb});
}
