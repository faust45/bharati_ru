function(e) {
  $(this).trigger('currentChanged');
  $('#edit_form').trigger('editPublication', this);

  return false;
}
