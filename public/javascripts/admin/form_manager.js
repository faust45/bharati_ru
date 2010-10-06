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
      if (View.Album.current) {
        self.editAlbum(View.Album.currentDocID);
      }
    });

    $(document).bind('currentTrackChanged', function(e, trackID) {
      self.editTrack(trackID);
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

    View.AlbumForm.editAlbum(id);
  },

  editTrack: function(id) {
    $(this.albumFormID).hide();
    $(this.trackFormID).show();

    View.TrackForm.editTrack(id);
  }
}
