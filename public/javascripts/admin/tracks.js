//--------------------------------------------------------------
//Initialization

$(document).ready(function() {
  LastTrackList.init($('#last_tracks ul'));

  $(document).bind('keydown', 'a', function() {
    Nav.openAlbums();
  });

  $(document).bind('keydown', 'j', function() {
    LastTrackList.goNext();
  });

  $(document).bind('keydown', 'k', function() {
    LastTrackList.goPrev();
  });

  $(document).focus();
  $('#add_new_track').asAddNewTrack();
});

LastTrackList = {
  current: null,

  init: function(ul) {
    this.ul = $(ul);
    var self = this;

    ul.find('li').each(function() {
      var li = $(this);

      li.click(function() {
        self.setCurrent(li);
        return false;
      });
    });

    $(document).bind('addNewTrack', function(e, track) {
      self.addNewTrack(track);
    });

    this.setCurrent(this.ul.find('li:first'));
  },

  addNewTrack: function(track) {
    var self = this;
    var template = '{{#doc}}<li data-id="{{_id}}"><span class="ico"><a href="">{{title}}</a></span></li>{{/doc}}';
       
    var html = Mustache.to_html(template, {doc: track});
    this.ul.prepend(html);
    var newLi = this.ul.find('li:first');
    newLi.effect("highlight", {}, 5000);
    newLi.click(function() {
      self.setCurrent(newLi);
      return false;
    });
  },

  goNext: function() {
    var next = this.current.next();
    if(next[0]) {
      this.setCurrent(next);
    }
  },

  goPrev: function() {
    var prev = this.current.prev();
    if(prev[0]) {
      this.setCurrent(prev);
    }
  },

  setCurrent: function(li) {
    if (this.current) {
      this.current.removeClass('current');
    }

    this.current = li;
    this.current.addClass('current');

    var id = this.current.attr('data-id');
    $(document).trigger('currentTrackChanged', [id]);
  }
}


$.fn.asAddNewTrack = function() {
  $(this).uploader = new qq.FileUploader({
    element: this[0],
    action: '/admin/audios/upload/new',
    allowedExtensions: ['mp3'],
    onComplete: function(id, fileName, responseJSON) {
      if (responseJSON.doc) {
        $(document).trigger('addNewTrack', [responseJSON.doc]);
      }
    }
  });
}
