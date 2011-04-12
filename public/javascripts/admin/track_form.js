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
  
  View.TrackForm.setSaveButton($('#track_form_tabs img'));
  var html = View.TrackForm.html();

  $('#edit_track_form').append(html);
  $('#track_form_tabs ul').behavior(TabsBehavior);
});


//--------------------------------------------------------------
View.TrackForm = { 
  paramsSpace: 'track',
  saveURL: '/admin/audios/save',
  deleteURL: '/admin/audios/destroy',
  fields: {},

  buildForm: function() {
    var self = this;
    this.cont = $('<form>');
    var fields = this.fields;
    var deleteTrack = function() { self.deleteTrack() };

    fields.title      = StringInput.create();
    fields.authorID   = AuthorInput.create();
    fields.tags       = TagsInput.create();
    fields.recordDate = DateInput.create();
    fields.bookmarks  = SimpleInput.create('textarea', {cols: '60', rows: '15'});
    fields.mp3File    = Mp3FileInput.create();
    fields.albums     = AlbumsInput.create();
    fields.deleteButton = Button.create('/images/delete.png', deleteTrack);
    fields.photos       = PhotosInput.create('/admin/audios/upload/photo');
    fields.extracts     = SimpleInput.create('textarea', {cols: '60', rows: '15'});
    fields.description  = SimpleInput.create('textarea', {cols: '60', rows: '15', 'data-label': 'Description'});
    fields.keywords     = SimpleInput.create('textarea', {cols: '60', rows: '15', 'data-label': 'Keywords'});

    var basicInfo = new FieldSet(fields, ['title', 'authorID', 'recordDate', 'tags']);
    var bookmarks = new FieldSet(fields, ['bookmarks', 'extracts']);
    var mp3File   = new FieldSet(fields, ['mp3File', 'deleteButton']);
    var albums    = new FieldSet(fields, ['albums']);
    var photos    = new FieldSet(fields, ['photos']);
    var seo       = new FieldSet(fields, ['description', 'keywords']);

    this.append([basicInfo, bookmarks, albums, photos, mp3File, seo]);

    this.listenChanges();

    return this.cont;
  },

  editDoc: function(trackID) {
    var self = this;
    Model.Track.get(trackID, function(doc) {
      self.doc = doc;
      self.refresh();
    });
  },

  deleteTrack: function() {
    var id = this.doc._id;
    if (confirm('Ты реально хочеш удалить?')) {
      $.ajax({
        url: this.deleteURL,
        data: {id: id},
        success: function(resp) {
          $(document).trigger('trackDestroy', [id]);
        }
      });
    }
  }

};


$.extend(View.TrackForm, FormBase);


//----------------------------------------------------------------------

/*
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
*/


//----------------------------------------------------------------------
Mp3FileInput = {
  create: function() {
    var node = document.createDocumentFragment();
    var div = $('<div>', {id: 'mp3_file_upload'});

    var label = $("<label />");
    var checkBox = $("<input type='checkbox' />");
    label.append("зменить теги");
    label.append(checkBox);

    var isNeedUpdateInfo = function() {
      return checkBox.is(':checked');
    };

    ctl = {
      refresh: function(docID) {
        this.trackID = docID;
      },

      getData: function() {
      }
    };

    var uploader = new qq.FileUploader({
      element: div[0],
      action: '/admin/audios/upload/replace_source',
      multiple: false,
      allowedExtensions: ['mp3'],
      onSubmit: function(id, fileName) {
        uploader.setParams({
          need_update_info: isNeedUpdateInfo(),
          track_id: ctl.trackID
        });
      },
      onComplete: function(id, fileName, responseJSON) {
        if (responseJSON.doc) {
          div.effect("highlight", {}, 3000);
          //self.hideFromSuccessList(id);
          //self.update(responseJSON.doc)
        }
      }
    });

    node.ctl = ctl;
    node.appendChild(div[0]);
    node.appendChild(label[0]);
    return node;
  }
};

/*
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
*/
