function(doc) {
  function if_new() {
    return doc._id == undefined;
  }

  return {doc: doc, if_new: if_new};
}
