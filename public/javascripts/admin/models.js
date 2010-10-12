Model = {};

Model.Album = {
  viewAll: '_design/Album/_view/all',

  all: function(fun) {
    db.view(this.viewAllUrl, {include_docs: true}, function(data) {
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
  ddoc: '_design/Audio/_view/',
  viewAll: 'all',
  viewLast: 'by_last',
  viewAuthorLast: 'by_author_last',
  viewAuthorLastPages: 'by_author_last_pages',

  get: function(id, fun) {
    db.getDoc(id, fun);
  },

  last: function(options, fun) {
    var authorID = Model.Author.current;
    if (authorID) {
      options = $.extend(options, {key: authorID});
      db.view(this.ddoc + this.viewAuthorLast, options, fun);
    } else {
      db.view(this.ddoc + this.viewLast, options, fun);
    }
  },

  lastPages: function(fun) {
    var authorID = Model.Author.current;
    var options;
    var callback = function(data){
      fun(data.rows[0].value);
    };

    if (authorID) {
      //options = {startkey: [authorID, {}], endkey: [authorID], descending: true};
      options = {reduce: true, key: authorID};
      db.view(this.ddoc + this.viewAuthorLastPages, options, callback);
    } else {
      options = {reduce: true};
      db.view(this.ddoc + this.viewAuthorLastPages, options, callback);
    }
  }
}

Model.Author = {
  viewAllUrl: '_design/Author/_view/all',
  current: null,

  thumbURL: function(doc) {
    return db.FileStore.attachmentURL(doc);
  },

  get: function(id, fun) {
    db.getDoc(id, fun);
  },

  all: function(fun) {
    db.view(this.viewAllUrl, {include_docs: true}, fun);
  },

}

db = {
  urlPrefix: "http://93.94.152.87:3000/",
  name: "rocks",

  uri: function() {
    return this.urlPrefix + this.name + '/';
  },

   getDoc: function(docId, fun) {
    $.getJSON(this.urlPrefix + this.name + '/' + docId + '?callback=?', function(data) {
      data.trim = trim;
      fun(data);
    });
  },

  view: function(url, options, fun) {
    if (options.reduce != true) {
      options =  $.extend({include_docs: true}, options); 
    }

    $.getJSON(this.urlPrefix + this.name + '/' + url + encodeOptions(options) + '&callback=?', function(data) {
      data.trim = trim;
      data.getIDs = getIDs;
      fun(data);
    });
  },

  all: function(model, options, fun) {
    this.view(model.viewAll, options, fun);
  },

  count: function(model, fun) {
    this.view(model.viewAll, {limit: 0}, function(data) {
      fun(parseInt(data.total_rows));
    });
  }
}

db.FileStore = {
  attachmentURL: function(doc) {
    var id = doc.doc_id, fileName = doc.file_name;
    return 'http://93.94.152.87:3000/rocks_file_store/' + id + '/' + fileName;
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
