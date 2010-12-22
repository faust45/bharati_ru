function(newDoc, oldDoc, userCtx, secObj) {
  var v = require("vendor/couchapp/lib/validate").init(newDoc, oldDoc, userCtx, secObj);

  v.assert(v.isBharatiRuAdmin(), 'Access Denid');
  //newDoc.created_at = new Date();
}
