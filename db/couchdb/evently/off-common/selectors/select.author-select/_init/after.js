function() {
  var id = EditDocForm.doc().author_id;
  $(this).find('option[value=' + id + ']').attr('selected', true);
}
