function(doc) {
  if (doc.extracts) {
    doc.extracts_raw = doc.extracts.join('\n\n')
  }

  return {doc: doc};
}

