function(resp) {
  var items = resp.rows;
  var obj = {items: items};

  obj.custom_class = function() {
    var is_unread = !this.is_read;
    return is_unread ? 'unread' : '';
  }

  return obj;
}

