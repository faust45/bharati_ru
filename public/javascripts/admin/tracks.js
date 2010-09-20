//--------------------------------------------------------------
//Initialization

$(document).ready(function() {
  LastTrackList.init($('#last_tracks ul'));

  $(document).bind('keydown', 'j', function() {
    console.log('j is down');
    LastTrackList.goNext();
  });

  $(document).bind('keydown', 'k', function() {
    console.log('k is down');
    LastTrackList.goPrev();
  });

  $(document).focus();

});

LastTrackList = {
  current: null,
  tracks: [],
  currentNum: 0,
  maxNum: 0,

  init: function(ul) {
    var self = this;

    ul.find('li').each(function(i) {
      var li = $(this);
      self.tracks.push(li);
      var id = li.attr('data-id');
      li.docId = id;
      li.itemNum = i; 

      li.click(function() {
        self.setCurrent(li);
        self.currentNum = li.itemNum;
        return false;
      });
    });

    var size =  $(this.tracks).size();
    if(0 < size) {
      this.maxNum = size - 1;
    } else {
      this.maxNum = 0;
    }


    this.setCurrent(this.tracks[0]);
  },

  goNext: function() {
    if(this.currentNum < this.maxNum) {
      this.currentNum = this.currentNum + 1;
      this.refresh();
    }
  },

  goPrev: function() {
    if(0 < this.currentNum) {
      this.currentNum = this.currentNum - 1;
      this.refresh();
    }
  },

  refresh: function() {
    this.setCurrent(this.tracks[this.currentNum]);
  },

  setCurrent: function(li) {
    if (this.current) {
      this.current.removeClass('current');
    }

    this.current = li;
    this.current.addClass('current');
    EditForm.editTrack(li.docId);
  }
}

