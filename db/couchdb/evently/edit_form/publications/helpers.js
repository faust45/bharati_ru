function(doc) {
  function if_pdf() {
    return doc.source_pdf;
  }

  function if_doc() {
    return doc.source_doc;
  }

  function if_not_pdf() {
    return !doc.source_pdf;
  }

  function if_not_doc() {
    return !doc.source_doc;
  }

  return {
    if_pdf: if_pdf,
    if_doc: if_doc,
    if_not_pdf: if_not_pdf,
    if_not_doc: if_not_doc
  }
}
