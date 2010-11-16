function(doc) {
  doc.extracts_raw = doc.extracts.join('\n\n')
  return {doc: doc};
}
