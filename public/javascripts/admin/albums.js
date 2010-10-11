//--------------------------------------------------------------
//Initialization

$(document).ready(function() {
  View.Album.init($('#albums_list'));
  View.Album.Track.init($('#album_track_list'));
});


//--------------------------------------------------------------
View.Album = {
  current: null,
  currentDocID: null,

  init: function(cont) {
    var self = this;
    this.cont = cont;

    this.refresh();

    $(document).bind('addNewTrack', function(e, track) {
      self.refresh();
    });
  },

  refresh: function() {
    var self = this;
    this.cont.html('');
    var template = "<li data-id='{{_id}}'><a>{{#trim}}{{title}}{{/trim}}</a> <b></b></li>";

    db.all(Model.Album, {}, function(data) {
      self.cont.mustache(template, data);
      self.bindEvents();
    });
  },

  bindEvents: function() {
    var self = this;
    this.cont.find('li').each(function() {
      var li = $(this);
      var id = li.attr('data-id');

      li.click(function() {
        self.setCurrent(li, id);
      });
    });
  },

  setCurrent: function(li, id) {
    if (this.current) {
      this.current.removeClass('current');
    }

    this.current = li;
    this.currentDocID = id;
    this.current.addClass('current');

    $(document).trigger('currentAlbumChanged', [id]);
  }
}


//--------------------------------------------------------------
View.Album.Track = {
  current: null,

  init: function(cont) {
    var self = this;
    this.cont = cont;

    this.refresh();

    $(document).bind('currentAlbumChanged', function(e, albumID) {
      self.refresh(albumID);
    });
  },

  refresh: function(albumID) {
    var self = this;
    this.cont.html('');
    var template = "<li data-id='{{_id}}'><a>{{#trim}}{{title}}{{/trim}}</a></li>";

    Model.Album.tracks(albumID, function(data) {
      self.cont.mustache(template, data);
      self.bindEvents();
    });
  },

  bindEvents: function() {
    var self = this;
    this.cont.find('li').each(function() {
      var li = $(this);
      var id = li.attr('data-id');

      li.click(function() {
        self.setCurrent(li, id);
      });
    });
  },

  setCurrent: function(li, id) {
    if (this.current) {
      this.current.removeClass('current');
    }

    this.current = li;
    this.current.addClass('current');

    $(document).trigger('currentTrackChanged', [id]);
  }

}

function AlbumDirBehavior(element, config) {
  var viewUrl  = '_design/Audio/_view/by_album';
  var template = "<ul class='tracks'> {{#rows}}<li>{{#doc}}<span class='ico'><a data-id='{{_id}}'>{{#trim}}{{title}}{{/trim}}{{/doc}}</a></span></li>{{/rows}} </ul>";
  
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

function pre() {
  return function(text, render) {
    return "<b> Stuff" + render(text) + '</b>';
  }
}
