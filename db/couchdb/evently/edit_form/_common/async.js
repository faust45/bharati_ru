function(cb, ev, id) {
  var id = id || $(ev.target).attr('data-id');
  function onload() {
    cb.apply(this, arguments);
    $(document).trigger('docLoaded', arguments);
  }

  var model = new DocModel(id, {onload: onload});
}
