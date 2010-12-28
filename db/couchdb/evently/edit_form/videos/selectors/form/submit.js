function(e) {
  var updater = e.data.args[1];
  updater(this);
  
  return false;
}
