function(doc) {
  function if_new() {
    return doc._id == undefined;
  }

  function if_not_new() {
    return !if_new();
  }

  return {doc: doc, if_new: if_new, if_not_new: if_not_new};
}
