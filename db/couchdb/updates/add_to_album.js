function(doc, req) {
  var field = req.query.field,
      item  = req.query.item,
      message = "not_added";

  if (field && item) { 
    if (!doc[field]) {
      doc[field] = [];
    }

    var album = doc[field];

    if (album.indexOf(item) == -1) {
      album.push(item);
    }

    message = "added";
  }

  return [doc, message];
}

