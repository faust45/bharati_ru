function(cb, ev, li) {
  var el = $(this);

  DocsStore.openDoc('events_main_album', {
    success: function(doc) {
      if (doc.events) {
        //if (doc.events.indexOf(EditDocForm.docId()) != -1) {
        //  el.attr('checked', true)
        //}
      }
    }
  });
}
