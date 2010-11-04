function() {
  var id = EditDocForm.currentDoc.author_id;
  $(this).find('option[value=' + id + ']').attr('selected', true);
}
