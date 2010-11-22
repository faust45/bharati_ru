function(doc, req) {
  var eventId = req.query.eventId;
  var message = "not_added";

  if (eventId) { 
    if (!doc.events) {
      doc.events = [];
    }

    if (doc.events.indexOf(eventId) == -1) {
      doc.events.push(eventId);
    }

    message = "added";
  }

  return [doc, message];
}

