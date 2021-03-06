//--------------------------------------------------------------
//Initialization

$(document).ready(function() {
  View.AlbumForm.setSaveButton($('#album_form_tabs img'));
  var html = View.AlbumForm.html();

  $('#edit_album_form').append(html);
  $('#album_form_tabs ul').behavior(TabsBehavior);
});


//--------------------------------------------------------------
View.AlbumForm = {
  paramsSpace: 'album',
  saveURL: '/admin/albums/save',
  fields: {},

  buildForm: function() {
    this.cont = $('<div>');
    var fields = this.fields;

    fields.title    = StringInput.create();
    fields.authorID = AuthorInput.create();
    fields.cover    = PhotoInput.create('/admin/albums/upload/cover');
    fields.sortType = SortType.create();
    fields.tracks   = SortTracks.create();

    var basicInfo  = new FieldSet(fields, ['title', 'authorID', 'cover']);
    var sortTracks = new FieldSet(fields, ['sortType', 'tracks']);

    this.append([basicInfo, sortTracks]);

    this.listenChanges();

    return this.cont;
  },

  editDoc: function(albumID) {
    var self = this;
    Model.Album.get(albumID, function(doc) {
      self.doc = doc;
      self.refresh();
    });
  }

};


$.extend(View.AlbumForm, FormBase);
