function(cb, ev, id) {
  var id = id;

  if (id == 'unbind') { 
    $(this).trigger('photoAlbumUnbind');
  } else {
    var model = new DocModel(id, {onload: cb});
  }
}
