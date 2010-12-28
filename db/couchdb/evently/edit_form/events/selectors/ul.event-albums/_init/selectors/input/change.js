function(e) {
  var el = $(this);
  var albumId = el.attr('data-id');
  var app = $$(this).app;

  function added(resp) {
  }

  function removed(resp) {
  }

  if(el.is(':checked')) {
    dbUpdate(app, 'add_to_events_main_album', albumId, {eventId: EditDocForm.docId()}, added);
  } else {
    dbUpdate(app, 'remove_from_events_main_album', albumId, {eventId: EditDocForm.docId()}, removed);
  }
}
