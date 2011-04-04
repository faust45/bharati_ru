function(e, collection) {
  var viewParams = {
    items: collection.rows, 
    link:  collection.type,
  };

  return viewParams;
}
