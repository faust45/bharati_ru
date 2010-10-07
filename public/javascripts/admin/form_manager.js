//--------------------------------------------------------------
//Initialization

$(document).ready(function() {
  View.Manager.init();
});


//--------------------------------------------------------------
View.Manager = {
  trackFormID: '#edit_track_form',
  albumFormID: '#edit_album_form',

  init: function() {
    var self = this;

    $(this.trackFormID).show();
    $(this.albumFormID).hide();

    $(document).bind('keydown', 'e', function() {
      var id = View.Album.currentDocID;
      if (id) {
        self.editAlbum(id);
      }
    });

    $(document).bind('keydown', 'f', function(e) {
      $('#content').blindToggle('slow');
    });

    $(document).bind('currentTrackChanged', function(e, id) {
      self.editTrack(id);
    });

    $(document).bind('keydown', 'j', function() {
      View.LastTracks.goNext();
    });

    $(document).bind('keydown', 'k', function() {
      View.LastTracks.goPrev();
    });

    //Need implement
    $(document).bind('keydown', 'a', function() {
      Nav.openAlbums();
    });
  },

  editAlbum: function(id) {
    $(this.trackFormID).hide();
    $(this.albumFormID).show();

    View.AlbumForm.editDoc(id);
  },

  editTrack: function(id) {
    $(this.albumFormID).hide();
    $(this.trackFormID).show();

    View.TrackForm.editDoc(id);
  }
}
