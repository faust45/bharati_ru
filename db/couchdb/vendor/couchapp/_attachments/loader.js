
function couchapp_load(scripts) {
  for (var i=0; i < scripts.length; i++) {
    document.write('<script src="'+scripts[i]+'"><\/script>')
  };
};

couchapp_load([
  "/_utils/script/sha1.js",
  "/_utils/script/json2.js",
  "/_utils/script/jquery.js",
  "/_utils/script/jquery.couch.js",
  "vendor/couchapp/jquery.couch.app.js",
  "vendor/couchapp/jquery.couch.app.util.js",
  "vendor/couchapp/jquery.mustache.js",
  "vendor/couchapp/jquery.evently.js",
  "vendor/couchapp/jquery.evently.couch.js",
  "scripts/fileuploader.js",
  "scripts/jquery.xhr.js",
  "scripts/app.js",
  "scripts/ext.js",
  "scripts/mime_types.js",
  "scripts/utils.js",
]);
