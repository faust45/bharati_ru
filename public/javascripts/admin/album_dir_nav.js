//--------------------------------------------------------------
//Initialization

$(document).ready(function() {
  var albums = $('#albums_dir ul a').behavior(AlbumDirBehavior);
});

//--------------------------------------------------------------


function AlbumDirBehavior(element, config) {
  var viewUrl  = '_design/Audio/_view/by_album';
  var template = "<ul class='tracks'> {{#rows}}<li>{{#doc}}<span class='ico'><a data-id='{{_id}}'>{{#trim}}{{title}}{{/trim}}{{/doc}}</a></span></li>{{/rows}} </ul>";
  var trim = function() {
    return function(text, render) {
      return render(this.title.substring(0, 40));
    }
  };

  var element = $(element);
  var id = element.attr('data-id');
  var tracks  = $('#tracks_list');

  element.click(function() {
    db.view(viewUrl, {include_docs: true, startkey: [id], endkey: [id, {}]}, function(data) {
      data.trim = trim;
      var html = Mustache.to_html(template, data);
      tracks.html(html);
    });

    return false;
  });
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

function pre() {
  return function(text, render) {
    return "<b> Stuff" + render(text) + '</b>';
  }
}
