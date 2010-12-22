function() {
  var self = this;
  function doLogout() {
    self.trigger('doLogout');
    return false;
  }

  return {
    "a[href=#logout]" : {"click" : doLogout}
  }
}
