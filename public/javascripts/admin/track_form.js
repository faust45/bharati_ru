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
    //fields.mp3File    = $('<div>', {id: 'mp3_file_upload'});
    //fields.albums     = $('<ul>', {'class': 'track-albums'});
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

  editTrack: function(trackId) {
    var self = this;
    Model.Track.get(trackId, function(doc) {
      self.doc = doc;
      self.refresh();
    });
  }

};


$.extend(View.TrackForm, FormBase);


//----------------------------------------------------------------------
AlbumsInput = function(inputUl) {
  var self = this;
  this.inputUl = inputUl;

  inputUl.find('li').each(function() {
    var li = $(this);
    var box = li.find('input[type=checkbox]');
    var response = li.find('span.response');
    var albumId = li.attr('data-id');

    li.albumId = albumId;
    li.box = box;
    li.response = response;

    li.click(function() {
      if (box.is(':checked')) {
        self.dropFromAlbum(li);
      } else {
        self.addToAlbum(li);
      };
    });
  });
};

AlbumsInput.prototype = {
  trackId: null,
  addUrl:  '/admin/albums/add_track',
  dropUrl: '/admin/albums/drop_track',

  refresh: function() {
    var self = this;
    var template = "{{#rows}}{{#doc}}<li data-id={{_id}}><input type=checkbox>{{title}}<span class='response'></span></li>{{/doc}}{{/rows}}"

    Model.Album.all(function(data) {
      self.inputUl.html('');
      self.inputUl.append(Mustache.to_html(template, data));
    });
  },

  addToAlbum: function(li) {
    this.request(this.addUrl, li.albumId, function() {
       li.box.attr('checked', true);
       li.response.html('added');
       li.response.show();
       li.response.css('color', 'green');
       li.response.fadeOut(3000);
    });
  },

  dropFromAlbum: function(li) {
    this.request(this.dropUrl, li.albumId, function() {
       li.box.attr('checked', false);
       li.response.html('removed');
       li.response.show();
       li.response.css('color', 'red');
       li.response.fadeOut(3000);
    });
  },

  update: function(trackId) {
    var self = this;
    this.trackId = trackId;

    this.cleanUp();
    Model.Album.trackAlbums(trackId, function(data) {
      $.each(data.rows, function() {
        self.checkAlbum(this.doc['_id']);
      });
    });
  },

  request: function(url, albumId, fun) {
    $.ajax({
      url: url,
      data: {album_id: albumId, track_id: this.trackId},
      cache: false,
      global: false,
      ifModified: false,
      complete: fun 
    });
  },

  cleanUp: function() {
    this.inputUl.find('li input[type=checkbox]').each(function() {
      $(this).attr('checked', false);
    });
  },

  checkAlbum: function(albumId) {
    this.inputUl.find('li[data-id=' + albumId + '] input[type=checkbox]').each(function() {
      $(this).attr('checked', true);
    });
  }
};


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
