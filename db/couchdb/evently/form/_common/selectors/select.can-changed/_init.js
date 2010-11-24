function(e, doc) {
  var attr = $(this).attr('name');
  var id = doc[attr];

  if (id) {
    $(this).find('option[value=' + id + ']').attr('selected', true);
  }
}

