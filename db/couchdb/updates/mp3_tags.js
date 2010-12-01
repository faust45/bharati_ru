function(doc, req) {
  var title = req.query.title,
      tags  = req.query.tags,
      author_id = req.query.author_id,
      album_id  = req.query.author_id,

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

