function(doc, req) {
  var eventId = req.query.eventId;
  var message = "not_remove";

  if (eventId && doc.events) { 
    var index = doc.events.indexOf(eventId);
    if (index) {
      doc.events.splice(index, 1);
    }

    message = "remove";
  }

  return [doc, message];
}

