function(doc) {
  doc.title = doc.title.replace(/"/, '\"');
  return {doc: doc};
}
