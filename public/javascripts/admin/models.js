Model = {};

Model.Album = {
  viewAll: 'albums_by_author',
  viewTracks: 'album_tracks',
  viewAlbumsByTrack: 'albums_by_track',

  all: function(fun) {
    db.viewDocs(this.viewAll, fun);
  },

  tracks: function(albumID, fun) {
    db.viewDocs(this.viewTracks, {startkey: [albumID], endkey: [albumID, {}]}, fun);
  },

  trackAlbums: function(trackID, fun) {
    db.viewDocs(this.viewAlbumsByTrack, {key: trackID}, function(data) {
      fun(data);
    });
  },

  get: function(id, fun) {
    db.getDoc(id, fun);
  }
}

Model.Track = {
  viewAll: 'all',
  viewLast: 'audios_all',
  viewAuthorLast: 'audios_by_author',

  get: function(id, fun) {
    db.getDoc(id, fun);
  },

  last: function(options, fun) {
    options = $.extend(options, {descending: true});

    var authorID = Model.Author.current;
    if (authorID) {
      options = $.extend(options, {key: authorID});
      db.viewDocs(this.viewAuthorLast, options, fun);
    } else {
      db.viewDocs(this.viewLast, options, fun);
    }
  },

  lastPages: function(fun) {
    var authorID = Model.Author.current;
    var options  = {reduce: true};
    var callback = function(data){
      if (data.rows[0]) {
        fun(data.rows[0].value);
      }
    };

    if (authorID) {
      options.key = authorID;
      db.view(this.viewAuthorLast, options, callback);
    } else {
      db.view(this.viewAuthorLast, options, callback);
    }
  }
}

Model.Author = {
  viewAll: 'authors_all',
  current: null,

  thumbURL: function(doc) {
    return db.FileStore.attachmentURL(doc);
  },

  get: function(id, fun) {
    db.getDoc(id, fun);
  },

  all: function(fun) {
    db.viewDocs(this.viewAll, {}, fun);
  },

}

db = {
  urlPrefix: "http://93.94.152.87:3000/",
  name: "rocks",
  ddoc: null,
  ddocID: "_design/global/",


  uri: function() {
    return this.urlPrefix + this.name + '/';
  },

  getDoc: function(docID, fun) {
    $.getJSON(this.uri() + docID + '?callback=?', function(data) {
      data.trim = trim;
      fun(data);
    });
  },

  view: function(viewName, options, fun) {
    options.reduce = options.reduce || false;

    if (!options.reduce) {
      options =  $.extend({include_docs: true}, options); 
    }

    $.getJSON(this.uri() + this.ddocID + '_view/' + viewName + encodeOptions(options) + '&callback=?', function(data) {
      data.trim = trim;
      data.getIDs = getIDs;
      fun(data);
    });
  },

  viewDocs: function(viewName, options, fun) {
    options = $.extend(options, {include_docs: true});
    this.view(viewName, options, fun);
  },

  all: function(model, options, fun) {
    this.view(model.viewAll, options, fun);
  },

  count: function(model, fun) {
    this.view(model.viewAll, {limit: 0}, function(data) {
      fun(parseInt(data.total_rows));
    });
  },

  isViewHaveReduce: function(viewName) {
    return this.ddoc['views'][viewName]['reduce']
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
