Model = {};

Model.Album = {
  all: function(fun) {
    var viewUrl = '_design/Album/_view/all';
    db.view(viewUrl, {include_docs: true}, function(data) {
      fun(data);
    });
  },

  tracks: function(albumID, fun) {
    var viewUrl = '_design/Audio/_view/by_album';

    db.view(viewUrl, {include_docs: true, startkey: [albumID], endkey: [albumID, {}]}, fun);
  },

  trackAlbums: function(trackId, fun) {
    var viewUrl = '_design/Album/_view/by_track';

    db.view(viewUrl, {include_docs: true, key: trackId}, function(data) {
      fun(data);
    });
  },

  get: function(id, fun) {
    db.getDoc(id, fun);
  }
}

Model.Track = {
  get: function(id, fun) {
    db.getDoc(id, fun);
  }
}

Model.Author = {
  viewAllUrl: '_design/Author/_view/all',

  all: function(fun) {
    db.view(this.viewAllUrl, {include_docs: true}, function(data) {
      fun(data);
    });
  }
}

db = {
  urlPrefix: "http://192.168.1.100:5984/",
  name: "rocks",

  getDoc: function(docId, fun) {
    $.getJSON(this.urlPrefix + this.name + '/' + docId + '?callback=?', function(data) {
      data.trim = trim;
      fun(data);
    });
  },

  view: function(url, options, fun) {
    $.getJSON(this.urlPrefix + this.name + '/' + url + encodeOptions(options) + '&callback=?', function(data) {
      data.trim = trim;
      data.getIDs = getIDs;
      fun(data);
    });
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

function trim() {
  return function(text, render) {
    return render(this.title.substring(0, 40));
  }
};

function getIDs() {
  var ids = [];

  $.each(this.rows, function() {
    ids.push(this.id);
  });

  return ids;
}
