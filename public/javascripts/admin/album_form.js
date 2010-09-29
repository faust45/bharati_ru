//--------------------------------------------------------------
//Initialization

$(document).ready(function() {
  View.AlbumForm.setSaveButton($('#album_form_menu img'));
  var html = View.AlbumForm.html();

  $('#album_form_tabs').html(html);
  $('#album_form_menu ul').behavior(TabsBehavior);
});


//--------------------------------------------------------------
View.AlbumForm = {
  paramsSpace: 'album',
  album: null,
  saveURL: '/admin/albums/save',

  paramsMap: {
    authors: 'author_id',
    sortType: 'is_hand_sort'
  },

  buildForm: function() {
    this.cont = $('<div>');
    var fields = this.fields;

    fields.title    = TitleInput.create();
    fields.authors  = AuthorInput.create();
    fields.cover    = PhotoInput.create();
    fields.sortType = SortType.create();
    fields.tracks   = SortTracks.create();

    var basicInfo  = new FieldSet(fields, ['title', 'authors', 'cover']);
    var sortTracks = new FieldSet(fields, ['sortType', 'tracks']);

    this.append([basicInfo, sortTracks]);

    this.listenChanges();

    return this.cont;
  },

  getID: function() {
    return this.album['_id'];
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

};


$.extend(View.AlbumForm, FormBase);
