function(e, a, b, c) {
  var updater = e.data.args[2];
  updater(this);
  
  return false;
}
