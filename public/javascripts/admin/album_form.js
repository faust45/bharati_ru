//--------------------------------------------------------------
//Initialization

$(document).ready(function() {
  var html = View.AlbumForm.html();
  $('#album_form_tabs').html(html);
  $('#album_form_menu ul').behavior(TabsBehavior);
});


//--------------------------------------------------------------
View.AlbumForm = {
  album: null,

  buildForm: function() {
    this.cont = $('<div>');
    var fields = this.fields;

    fields.title    = TitleInput.create();
    fields.authors  = AuthorInput.create();
    fields.cover    = PhotoInput.create();
    //fields.sortType = $('<label><input type="checkbox">Custom sort</label>');
    //fields.tracks   = $('<div>');
    this.buttonSave = $('#album_button_save');

    var basicInfo  = new FieldSet(fields, ['title', 'authors', 'cover']);
    var sortTracks = new FieldSet(fields, ['sortType', 'tracks']);

    this.append([basicInfo, sortTracks]);

    this.listenChanges();

    return this.cont;
  },

  html: function() {
    return this.buildForm();
  },

  editAlbum: function(albumID) {
    var self = this;
    Model.Album.get(albumID, function(doc) {
      self.album = doc;
      self.refresh();
    });
  },

  refresh: function() {
    this.refreshFields()
  },

  getAlbum: function() {
    return this.album;
  },

  dataChanged: function() {
    var pathSave  = '/images/save.png';
    this.buttonSave.attr('src', pathSave);
  },
};


$.extend(View.AlbumForm, FormBase);
