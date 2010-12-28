function(doc, req) {
  var duration = req.query.duration;

  if (duration) {
    doc.duration = Math.round(duration);
    doc.need_fetch_tags = true;
  }

  return [doc, "ok"];
}
