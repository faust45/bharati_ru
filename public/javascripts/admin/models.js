Album = {
  all: function(fun) {
    var viewUrl = '_design/Album/_view/all';
    db.view(viewUrl, {include_docs: true}, function(data) {
      fun(data);
    });
  },

  trackAlbums: function(trackId, fun) {
    var viewUrl = '_design/Album/_view/by_track';

    db.view(viewUrl, {include_docs: true, key: trackId}, function(data) {
      fun(data);
    });
  }
}

Track = {
  get: function(id, fun) {
    db.getDoc(id, function(track) {
      fun(track);
    });
  }
}

db = {
  urlPrefix: "http://192.168.1.100:5984/",
  name: "rocks",

  getDoc: function(docId, fun) {
    $.getJSON(this.urlPrefix + this.name + '/' + docId + '?callback=?', fun)
  },

  view: function(url, options, fun) {
    $.getJSON(this.urlPrefix + this.name + '/' + url + encodeOptions(options) + '&callback=?', fun)
  }
}

function encodeOptions(options) {
  var buf = [];
  if (typeof(options) === "object" && options !== null) {
    for (var name in options) {
      if ($.inArray(name, ["error", "success", "beforeSuccess", "ajaxStart"]) >= 0)
        continue;
      var value = options[name];
      if ($.inArray(name, ["key", "startkey", "endkey"]) >= 0) {
        value = toJSON(value);
      }
      buf.push(encodeURIComponent(name) + "=" + encodeURIComponent(value));
    }
  }
  return buf.length ? "?" + buf.join("&") : "";
}

function toJSON(obj) {
  return obj !== null ? JSON.stringify(obj) : null;
}
