function(e) {
  $(this).trigger('currentChanged');
  $('#edit_form').trigger('editAuthor', this);

  return false;
}
