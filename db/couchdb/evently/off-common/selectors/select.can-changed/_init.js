function() {
  var attr = $(this).attr('name');
  var id = EditDocForm.doc()[attr];
  if (id) {
    $(this).find('option[value=' + id + ']').attr('selected', true);
  }
}

