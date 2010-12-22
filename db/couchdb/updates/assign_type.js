function(doc, req) {
  var type = req.query.type;
  var message = "fail";

  if (type) { 
    doc.type = type;
    message = "ok";
  }

  return [doc, message];
}
