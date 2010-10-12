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
    var template = '<li data-id="{{_id}}"><a href="">{{record_date}}&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;{{title}}</a></li>';
    var self = this, ul = $(ul), ol = $('#last_tracks_pages');
    var pages, current;

    var goToPage = function(page, perPage) {
      var options = {limit: 10};
      options.skip = (page - 1) * perPage;

      Model.Track.last(options, function(data) {
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

    var init = function() {
      Model.Track.last({limit: 10}, function(data) {
        refresh(data);
      });

      if (pages) { pages.destroy(); }

      Model.Track.lastPages(function(total) {
        pages = new Paginator(ol, total, goToPage);
        pages.setCurPage(1);
      });
    },

    addNewTrack = function(track) {
      ul.mustache(template, track, 'prepend');
      var newLi = ul.find('li:first');
      newLi.effect("highlight", {}, 5000);
      newLi.click(function() {
        setCurrent(newLi);
        return false;
      });
    },

    removeTrack = function(id) {
      li = ul.find('li[data-id=' + id + ']');

      if (li) {
        li.removeClass("current");
        //Не понятно как почему нечочет работать li.effect("highlight", {}, 3000);?
        ul.effect("highlight", {}, 3000);
        li.fadeOut(3000);
      };
    };

    init();

    $(document).bind('addNewTrack', function(e, track) {
      addNewTrack(track);
    });

    $(document).bind('currentAuthorChanged', function(e, id) {
      init();
    });

    $(document).bind('trackDestroy', function(e, id) {
      removeTrack(id);
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
  var el = $('#upload_tracks_list')[0];
  $.log(el);

  $(this).uploader = new qq.FileUploader({
    element: this[0],
    _listElement: el, 
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
  $.log('total', total);
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
    },

    destroy: function() {
      ol.find('a').each(function() {
        $(this).parent().remove();
      });
    }
  };
}
