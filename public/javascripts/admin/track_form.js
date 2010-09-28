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
  
  EditForm = new TrackForm();
  var htmlForm = EditForm.buildForm();

  $('#form_tabs').append(htmlForm);
  $('#edit_menu ul').behavior(TabsBehavior);
});


//--------------------------------------------------------------
TrackForm = function(track) {
  this.track = track;
}

TrackForm.prototype = {
  fields: {},

  buildForm: function() {
    var fields = this.fields;
    this.form = $('<form>');

    fields.title   = $('<input>', {type: 'text', size: '25'});
    fields.authors = AuthorInput.create();
    fields.tags    = $('<input>', {type: 'text', size: '25'});
    fields.recordDate = $('<select></select><select></select><select></select>');
    fields.bookmarks  = $('<textarea>', {cols: '30', rows: '15'});
    fields.mp3File    = $('<div>', {id: 'mp3_file_upload'});
    fields.albums     = $('<ul>', {'class': 'track-albums'});
    fields.photos     = $('<div>', {id: 'photo_file_upload'});
    this.buttonSave   = $('#button_save');

    var basicInfo = new FieldSet(fields, ['title', 'authors', 'recordDate', 'tags']);
    var bookmarks = new FieldSet(fields, ['bookmarks']);
    var mp3File   = new FieldSet(fields, ['mp3File']);
    var albums    = new FieldSet(fields, ['albums']);
    var photos    = new FieldSet(fields, ['photos']);

    this.append([basicInfo, bookmarks, albums, photos, mp3File]);

    fields.tags.asTagsInput(); 
    fields.recordDate.asDateInput();
    fields.mp3File.asMp3FileInput();
    fields.photos.asPhotosInput();
    fields.albums.asAlbumsInput();

    this.init();

    return this.form;
  },

  init: function() {
    var self = this;

    this.listenChanges();

    this.buttonSave.click(function() {
      self.saveData();
    });

    $(document).bind('addNewTrack', function(e, track) {
      self.fields.albums.ctl.refresh();
    });
  },

  editTrack: function(trackId) {
    var self = this;
    Model.Track.get(trackId, function(track) {
      self.setTrack(track);
      self.dataNew();
    });
  },

  saveData: function() {
    var self = this;

    $.ajax({
      url: '/admin/audios/save',
      type: 'post',
      data: this.getData(),
      success: function(resp) {
        self.dataSaved();
      }
    });
  },

  getData: function() {
    return {
      track_id: this.currentTrack['_id'],
      title: this.getTitle(),
      tags:  this.getTags(),
      author_id:   this.getAuthorId(),
      record_date: this.getRecordDate(),
      bookmarks_raw:   this.getBookmarks()
    };
  },

  dataNew: function() {
    var pathSaved = '/images/saved.png';
    this.buttonSave.attr('src', pathSaved);
  },

  dataChanged: function() {
    var pathSave  = '/images/save.png';
    this.buttonSave.attr('src', pathSave);
  },

  dataSaved: function() {
    var pathSaved = '/images/saved.png';
    this.buttonSave.attr('src', pathSaved);
  },

  append: function(blocks) {
    var form = this.form;

    $.each(blocks, function() {
      form.append(this.html());
    });
  },

  setTrack: function(track) {
    this.currentTrack = track;

    this.setTitle(track.title);
    this.setAuthor(track.author_id);
    this.setRecordDate(track.record_date);
    this.setTags(track.tags);
    this.setAlbums(track['_id']);
    this.setPhotos(track);
    this.setMp3File(track);
  },

  setTitle: function(value) {
    this.fields.title.attr('value', value);
  },

  setAuthor: function(authorId) {
    this.fields.authors.setSelected(authorId);
  },

  setRecordDate: function(value) {
    this.fields.recordDate.ctl.update(value);
  },

  setTags: function(tags) {
    this.fields.tags.ctl.update(tags);
  },

  setAlbums: function(trackId) {
    if(this.fields.albums.ctl) {
      this.fields.albums.ctl.update(trackId);
    }
  },

  setPhotos: function(track) {
    this.fields.photos.ctl.update(track);
  },

  setMp3File: function(track) {
    this.fields.mp3File.ctl.update(track);
  },

  getTitle: function() {
    return this.fields.title.val();
  },

  getTags: function() {
    return this.fields.tags.ctl.getValues();
  },

  getAuthorId: function() {
    return this.fields.authors.ctl.getSelected();
  },

  getRecordDate: function() {
    return  this.fields.recordDate.ctl.getSelected();
  },

  getBookmarks: function() {
    return this.fields.bookmarks.val();
  },


  listenChanges: function() {
    var self = this;

    this.form.bind('trackForm.changed', function() {
      self.dataChanged();
    });

    this.fields.title.keypress(function() {
      self.form.trigger('trackForm.changed');
    });

    this.fields.tags.bind('tagsChanged', function() {
      self.form.trigger('trackForm.changed');
    });

    this.fields.recordDate.bind('recordDateChanged', function() {
      self.form.trigger('trackForm.changed');
    });

    this.fields.authors.bind('authorChanged', function() {
      self.form.trigger('trackForm.changed');
    });

    this.fields.bookmarks.bind('bookmarksChanged', function() {
      self.form.trigger('trackForm.changed');
    });

    this.fields.bookmarks.keypress(function() {
      self.form.trigger('trackForm.changed');
    });
  }
};


//----------------------------------------------------------------------
TagsInput = function(inputField) {
  var self = this;
  this.inputField = inputField;
  this.tagsCont = $('<div>', {'class': 'tags'});

  var ico = $('<img>', {'class': '', src: '/images/tags.png'});
  var addImg = $('<img>', {'class': 'add-button', src: '/images/add-icon.png'});
  var link = $('<a>', {href: ''}).append(addImg); 

  var block = this.inputField.parent();
  this.tagsCont.append(ico);
  block.prepend(this.tagsCont);
  block.append(link);

  link.click(function() {
    self.fireAddNewTag();
    return false;
  });
}

TagsInput.prototype = {
  getValues: function() {
    var tags = [];
    this.tagsCont.find('input[type=checkbox]').each(function() {
      tags.push($(this).attr('value'));
    });

    return tags;
  },

  fireAddNewTag: function() {
    this.add(this.inputField.attr('value'));
    $(this.inputField).trigger('tagsChanged');            
  },

  fireDropTag: function() {
    $(this.inputField).trigger('tagsChanged');            
  },

  add: function(value) {
    var self = this;
    var existsTag = this.getTag(value);

    if (!existsTag) {
      var label = $('<label>');
      var checkbox = $('<input>', {type: 'checkbox', value: value});
      checkbox.attr('checked', true);

      label.append(checkbox);
      label.append(value);
      label.click(function() { 
        $(this).remove();
        self.fireDropTag();
      });

      this.tagsCont.append(label);
    } else {
      existsTag.effect("highlight", {}, 3000);
    }
  },

  update: function(newTags) {
    var self = this;

    this.tagsCont.find('label').each(function() {
      $(this).remove();
    });

    $.each(newTags, function(i) {
      self.add(newTags[i]);
    });
  },

  getTag: function(value) {
    var checkbox = this.tagsCont.find('input[value=' + value + ']');

    if(0 < checkbox.size()) {
      return checkbox.parent();
    }
  }
};


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
function DateSelect(inputs) {
  this.inputs = inputs;
  this.yearInput  = $(inputs[0]);
  this.monthInput = $(inputs[1]);
  this.dayInput   = $(inputs[2]);

  var years  = range(1900, 2010);
  var months = range(1, 12);
  var days   = range(1, 31);

  var html = Mustache.to_html("<option></option>{{#years}}<option value={{.}}>{{.}}</option>{{/years}}", {years: years});
  this.yearInput.append(html);
  var html = Mustache.to_html("<option></option>{{#years}}<option value={{.}}>{{.}}</option>{{/years}}", {years: months});
  this.monthInput.append(html);
  var html = Mustache.to_html("<option></option>{{#years}}<option value={{.}}>{{.}}</option>{{/years}}", {years: days});
  this.dayInput.append(html);


  var self = this;
  this.yearInput.change(function() {
    self.inputs.trigger('recordDateChanged');
  });
  this.monthInput.change(function() {
    self.inputs.trigger('recordDateChanged');
  });
  this.dayInput.change(function() {
    self.inputs.trigger('recordDateChanged');
  });
}

DateSelect.prototype = {
  update: function(newDate) {
    var date = this.parseDate(newDate);

    this.currentDate = date;
    if (date) {
      this.yearInput.setSelected(date.getFullYear());  
      this.monthInput.setSelected(date.getMonth());  
      this.dayInput.setSelected(date.getDate());  
    } else {
      this.yearInput.setSelected('');
      this.monthInput.setSelected('');
      this.dayInput.setSelected('');
    }
  },

  parseDate: function(input, format) {
    format = format || 'yyyy-mm-dd'; // default format

    if (input) {
      var parts = input.match(/(\d+)/g), 
          i = 0, fmt = {};
      // extract date-part indexes from the format
      format.replace(/(yyyy|dd|mm)/g, function(part) { fmt[part] = i++; });

      return new Date(parts[fmt['yyyy']], parts[fmt['mm']], parts[fmt['dd']]);
    }
  },

  getSelected: function() {
    var year  = this.yearInput.val();
    var month = this.monthInput.val();
    var day   = this.dayInput.val();

    return (year + '-' + month + '-' + day);
  }
}


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


//----------------------------------------------------------------------
function range(first, last) {
  var arr = [];

  for(var i=first; i <= last; i=i+1) {
    arr.push(i);
  }

  return arr;
}
