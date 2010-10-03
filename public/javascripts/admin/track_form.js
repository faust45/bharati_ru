//--------------------------------------------------------------
//Initialization

$(document).ready(function() {
  $(document).ajaxError(function(e, xhr, settings, exception) { 
    alert('error in: ' + settings.url + 'exeption:' + exception + ' \n'+'error:\n' + xhr.responseText ); 
  }); 
  
  $.ajaxSetup({
    'success': function() {
    },
    'complete': function() {
    }
  });
  
  View.TrackForm.setSaveButton($('#edit_menu img'));
  var html = View.TrackForm.html();

  $('#form_tabs').append(html);
  $('#edit_menu ul').behavior(TabsBehavior);
});


//--------------------------------------------------------------
View.TrackForm = { 
  paramsSpace: 'track',
  saveURL: '/admin/audios/save',
  fields: {},

  buildForm: function() {
    this.cont = $('<div>');
    var fields = this.fields;

    fields.title      = StringInput.create();
    fields.authorID   = AuthorInput.create();
    fields.tags       = TagsInput.create();
    fields.recordDate = DateInput.create();
    fields.bookmarks  = SimpleInput.create('textarea', {cols: '30', rows: '15'});
    fields.albums     = AlbumsInput.create();
    //fields.mp3File    = $('<div>', {id: 'mp3_file_upload'});
    //fields.photos     = $('<div>', {id: 'photo_file_upload'});

    var basicInfo = new FieldSet(fields, ['title', 'authorID', 'recordDate', 'tags']);
    var bookmarks = new FieldSet(fields, ['bookmarks']);
    var mp3File   = new FieldSet(fields, ['mp3File']);
    var albums    = new FieldSet(fields, ['albums']);
    var photos    = new FieldSet(fields, ['photos']);

    this.append([basicInfo, bookmarks, albums, photos, mp3File]);

    this.listenChanges();

    return this.cont;
  },

  editTrack: function(trackID) {
    var self = this;
    Model.Track.get(trackID, function(doc) {
      self.doc = doc;
      self.refresh();
    });
  }

};


$.extend(View.TrackForm, FormBase);


//----------------------------------------------------------------------
PhotosInput = function(input) {
  var self = this;
  this.input = $(input);

  this.imgBlock = $('<div>', { 'class': 'track_photos'});
  this.input.parent().append(this.imgBlock);

  this.uploader = new qq.FileUploader({
    element: input[0],
    action: '/admin/audios/upload/photo',
    allowedExtensions: ['jpg', 'jpeg', 'png', 'gif'],
    onSubmit: function(id, fileName) {
      self.uploader.setParams({
        track_id: self.trackId
      });
    },
    onComplete: function(id, fileName, responseJSON) {
      if (responseJSON.doc) {
        self.hideFromSuccessList(id);
        self.update(responseJSON.doc)
      }
    }
  });
}

PhotosInput.prototype = {
  hideFromSuccessList: function(num) {
    var list = this.input.find('ul.qq-upload-list li');
    var li = list[num];
    if (li) {
      $(li).fadeOut(5000);
    }
  },

  update: function(track) {
    var self = this; 
    this.trackId = track['_id'];
    this.photos  = track['photos_attachments'];

    this.imgBlock.html('');
    if (this.photos) {
      $.each(this.photos, function() {
        if (this.thumbs.small) {
          self.imgBlock.append($('<img />', {src: this.thumbs.small.url}));
        }
      });
    }
  }
}


//----------------------------------------------------------------------
Mp3FileInput = function(input) {
  var self = this;
  this.input = input;
  this.fileCont = $('<div>');
  this.input.parent().prepend(this.fileCont);

  var label = $("<label />");
  this.checkBox = $("<input type='checkbox' />");
  label.append("зменить теги");
  label.append(this.checkBox);
  this.input.parent().append(label);

  this.uploader = new qq.FileUploader({
    element: input[0],
    action: '/admin/audios/upload/replace_source',
    multiple: false,
    allowedExtensions: ['mp3'],
    onSubmit: function(id, fileName) {
      self.uploader.setParams({
        need_update_info: self.isNeedUpdateInfo(),
        track_id: self.trackId
      });
    },
    onComplete: function(id, fileName, responseJSON) {
      if (responseJSON.doc) {
        self.hideFromSuccessList(id);
        self.update(responseJSON.doc)
      }
    }
  });
};

Mp3FileInput.prototype = {
  isNeedUpdateInfo: function() {
    return this.checkBox.is(':checked');
  },

  hideFromSuccessList: function(num) {
    var list = this.input.find('ul.qq-upload-list li');
    var li = list[num];
    if (li) {
      $(li).fadeOut(5000);
    }
  },

  update: function(track) {
    var self = this; 
    this.trackId = track['_id'];
    this.file = track.source_attachments[0];

    this.fileCont.html('');
    var a = $('<a>' + this.file.file_name + '</a>');
    a.attr('href', this.file.url);
    this.fileCont.append(a);
  }
};
