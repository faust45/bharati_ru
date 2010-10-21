function(keys, values, rereduce) {
  if (!rereduce) {
//    log(values);
    var pages = [];
    var perPage = 10;
    var counter = 0;

    pages.push(values[0]);
    for(var i in keys) {
      if (counter == perPage) {
        var id = values[i];
        pages.push(id);
        counter = 0;
      } else {
        counter = counter + 1;
      }
    }

//    log('in !re pages');
//    log(pages);
    return pages;
  } else {
    return values;
  }
}
