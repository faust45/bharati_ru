//--------------------------------------------------------------
//Initialization

$(document).ready(function() {
  $(document).ajaxError(function(e, xhr, settings, exception) { 
    alert('error in: ' + settings.url + ' \n'+'error:\n' + xhr.responseText ); 
  }); 
  
  $.ajaxSetup({
    'success': function() {
      console.log('in global stuff success');
    },
    'complete': function() {
      console.log('in global stuff complete');
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
    fields.authors = $('<select>');
    fields.tags    = $('<input>', {type: 'text', size: '25'});
    fields.recordDate = $('<select></select><select></select><select></select>');
    fields.bookmarks  = $('<textarea>', {cols: '30', rows: '15'});
    fields.mp3File    = $('<div>', {id: 'mp3_file_upload'});
    fields.albums     = $('<ul>', {'class': 'track-albums'});
    fields.photos     = $('<div>', {id: 'photo_file_upload'});

    var basicInfo = new FieldSet(fields, ['title', 'authors', 'recordDate', 'tags']);
    var bookmarks = new FieldSet(fields, ['bookmarks']);
    var mp3File   = new FieldSet(fields, ['mp3File']);
    var albums    = new FieldSet(fields, ['albums']);
    var photos    = new FieldSet(fields, ['photos']);

    this.append([basicInfo, bookmarks, albums, photos, mp3File]);

    fields.tags.asTagsInput(); 
    fields.authors.asAuthorsInput(); 
    fields.recordDate.asDateInput();
    fields.mp3File.asMp3FileInput();
    fields.photos.asPhotosInput();
    fields.albums.asAlbumsInput();

    return this.form;
  },

  append: function(blocks) {
    var form = this.form;

    $.each(blocks, function() {
      form.append(this.html());
    });
  },

  editTrack: function(trackId) {
    var self = this;
    Track.get(trackId, function(track) {
      self.setTrack(track);
    });
  },

  setTrack: function(track) {
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
    this.fields.albums.ctl.update(trackId);
  },

  setPhotos: function(track) {
    this.fields.photos.ctl.update(track);
  },

  setMp3File: function(track) {
    this.fields.mp3File.ctl.update(track);
  }
};


//----------------------------------------------------------------------
function FieldSet(fieldsHash, names) {
  fields = [];

  $.each(names, function() {
    fields.push(fieldsHash[this]);
  });

  this.fields = fields;
};

FieldSet.prototype = {
  fields: null,

  html: function() {
    var wrap = $('<div>', {'class': 'tab'});

    $.each(this.fields, function() {
      var div = $('<div>', {'class': 'input'})
      div.append(this);
      wrap.append(div);
    });

    return wrap;
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
  fireAddNewTag: function() {
    this.add(this.inputField.attr('value'));
  },

  add: function(value) {
    var existsTag = this.getTag(value);

    if (!existsTag) {
      var label = $('<label>');
      var checkbox = $('<input>', {type: 'checkbox', value: value});
      checkbox.attr('checked', true);

      label.append(checkbox);
      label.append(value);
      label.click(function(){ $(this).remove() });

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
    Album.trackAlbums(trackId, function(data) {
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
}

DateSelect.prototype = {
  update: function(newDate) {
    var date = new Date(newDate);

    this.yearInput.setSelected(date.getFullYear());  
    this.monthInput.setSelected(date.getMonth());  
    this.dayInput.setSelected(date.getDay());  
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


//----------------------------------------------------------------------
$.fn.asPhotosInput = function() {
  this.ctl = new PhotosInput(this); 

  };

$.fn.asTagsInput = function() {
  this.ctl = new TagsInput(this);
};

$.fn.asAuthorsInput = function() {
  var self = this;
  var viewUrl = '_design/Author/_view/all';
  var template = "{{#rows}}{{#doc}}<option value={{_id}}>{{display_name}}</option>{{/doc}}{{/rows}}"

  self.append($('<option>Select Author</option>'));
  db.view(viewUrl, {include_docs: true}, function(data) {
    self.append(Mustache.to_html(template, data));
  });
};

$.fn.asDateInput = function() {
  this.ctl = new DateSelect(this);
}

$.fn.asAlbumsInput = function() {
  var self = this;
  var template = "{{#rows}}{{#doc}}<li data-id={{_id}}><input type=checkbox>{{title}}<span class='response'></span></li>{{/doc}}{{/rows}}"

  Album.all(function(data) {
    self.append(Mustache.to_html(template, data));
    self.ctl = new AlbumsInput(self);
  });
}

$.fn.asMp3FileInput = function() {
  this.ctl = new Mp3FileInput(this);
}

$.fn.setSelected = function(value) {
  var option = this.find('option[value=' + value + ']');
  option.attr('selected', 'selected');
}
