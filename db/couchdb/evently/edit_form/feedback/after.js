function() {
  if (EditDocForm.docIsUnread()) {
    EditDocForm.markAsRead(function() {
      //$('#edit_form').trigger('feedback', {})
    });
  }
}
