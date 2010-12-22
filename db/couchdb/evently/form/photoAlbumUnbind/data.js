function(resp) {
  var notInAlbums = [];

  for(var i in resp.rows) {
    var obj = resp.rows[i];

    if (obj.value == 1) {
      notInAlbums.push(obj.key);
    }
  }

  return {items: notInAlbums};
}
