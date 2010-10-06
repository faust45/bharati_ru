//--------------------------------------------------------------
//Evens:
//  addNewTrack, currentTrackChanged
//
//
//Initialization

$(document).ready(function() {
  View.LastTracks.init($('#last_tracks'));

  $('.newTrack').asAddNewTrack();
});


//--------------------------------------------------------------
View.LastTracks = {
  current: null,

  init: function(ul) {
    var template = '<li data-id="{{_id}}"><a href="">{{title}}</a></li>';
    var self = this, ul = $(ul), ol = $('#last_tracks_pages');
    var current;

    var goToPage = function(page, perPage) {
      var options = {limit: 10};
      options.skip = (page - 1) * perPage;

      db.all(Model.Track, options, function(data) {
        pages.setCurPage(page)
        refresh(data);
      });
    },

    getCurrent = function() {
      return current;
    },

    setCurrent = function(li) {
      if (current) {
        current.removeClass('current');
      }

      current = li;
      current.addClass('current');

      var id = current.attr('data-id');
      $(document).trigger('currentTrackChanged', [id]);
    },

    refresh = function(data) {
      ul.mustache(template, data);
      setCurrent(ul.find('li:first'));

      ul.find('li').each(function() {
        var li = $(this);

        li.click(function() {
          setCurrent(li);
          return false;
        });
      });
    };

    this.setCurrent = setCurrent; 
    this.getCurrent = getCurrent; 

    //init
    db.all(Model.Track, {limit: 10}, function(data) {
      refresh(data);
      pages = new Paginator(ol, data.total_rows, goToPage);
      pages.setCurPage(1);
    });


    $(document).bind('addNewTrack', function(e, track) {
      this.addNewTrack(track);
    });
  },

  addNewTrack: function(track) {
    var self = this;
       
    this.ul.Mustache(template, track, 'prepend');
    var newLi = this.ul.find('li:first');
    newLi.effect("highlight", {}, 5000);
    newLi.click(function() {
      self.setCurrent(newLi);
      return false;
    });
  },

  goNext: function() {
    var next = this.getCurrent().next();
    if(next[0]) {
      this.setCurrent(next);
    }
  },

  goPrev: function() {
    var prev = this.getCurrent().prev();
    if(prev[0]) {
      this.setCurrent(prev);
    }
  }
}


//--------------------------------------------------------------
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
};

Paginator = function(ol, total, funNewPage) {
  var perPage = 10;
  var template = '<li> <a data-num={{.}} href="#">{{.}}</a></li>';
  var pagesMax = total / perPage;

  ol.mustache(template, range(1, pagesMax), 'append');
  ol.find('a').each(function() {
    var a  = $(this);
    var page = a.attr('data-num');

    a.click(function() { 
      funNewPage(page, perPage);
      return false; 
    });
  });


  return {
    setCurPage: function(page) {
      ol.find('a.active').removeClass('active');
      ol.find('a[data-num=' + page + ']').addClass('active');
    }
  };
}
