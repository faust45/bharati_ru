
function couchapp_load(scripts) {
  for (var i=0; i < scripts.length; i++) {
    document.write('<script src="'+scripts[i]+'"><\/script>')
  };
};

couchapp_load([
  "/_utils/script/sha1.js",
  "/_utils/script/json2.js",
  "scripts/jquery-1.4.4.js",
  "/_utils/script/jquery.couch.js",
  "vendor/couchapp/jquery.couch.app.js",
  "vendor/couchapp/jquery.couch.app.util.js",
  "vendor/couchapp/jquery.mustache.js",
  "vendor/couchapp/jquery.evently.js",
  "vendor/couchapp/jquery.evently.couch.js",
  "vendor/couchapp/jquery.pathbinder.js",
  "scripts/jquery-ui.min.js",
  "scripts/jquery.ui.datepicker.js",
  "scripts/fileuploader.js",
  "scripts/jquery.form.js",
  "scripts/doc_model.js",
  "scripts/doc_collection.js",
  "scripts/models.js",
  "scripts/utils.js",
  "scripts/app.js",
  "scripts/form2object.js",
  "scripts/ext.js",
  "scripts/file.js",
  "scripts/mime_types.js",
  "scripts/typewatch.js"
]);
