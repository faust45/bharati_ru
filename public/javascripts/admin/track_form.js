//--------------------------------------------------------------
//Initialization

$(document).ready(function() {
  //$.ajaxSetup({
  //  'beforeSend': function(xhr) {xhr.setRequestHeader("Accept", "*/*")},
  //  'complete': function() {
  //    console.log('in global stuff complete');
  //  }
  //});
  
  var f = new TrackForm();
  EditForm = f;
  var htmlForm = f.buildForm();

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
    fields.mp3File    = $('<input>', {type: 'file', name: 'mp3_file', id: 'mp3_file_upload'});
    fields.albums     = $('<ul>', {'class': 'track-albums'});
    fields.photos     = $('<div>', {id: 'photo_file_upload'});

    var basicInfo = new FieldSet(fields, ['title', 'authors', 'recordDate', 'tags']);
    var bookmarks = new FieldSet(fields, ['bookmarks']);
    var mp3File   = new FieldSet(fields, ['mp3File']);
    var albums    = new FieldSet(fields, ['albums']);
    var photos    = new FieldSet(fields, ['photos']);

    this.append([basicInfo, bookmarks, albums, photos, mp3File]);

    //fields.tags.asTagsInput(); 
    //fields.authors.asAuthorsInput(); 
    //fields.recordDate.asDateInput();
    //fields.mp3File.asMp3FileInput();
    fields.photos.asPhotosInput();
    //fields.albums.asAlbumsInput();

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
    db.getDoc(trackId, function(track) {
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
    //this.setMp3File(track.source_attachments[0]);
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

  setMp3File: function(sourceFile) {
    this.fields.mp3File.ctl.update(sourceFile);
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
  addUrl: '/admin/albums/add_track',
  delUrl: '/admin/albums/drop_track',
  trackAlbumsView: '_design/Album/_view/by_track',

  addToAlbum: function(li) {
    var box = li.find('input[type=checkbox]');
    var albumId = li.attr('data-id');

    console.log('in add track');
    li.ajaxSuccess(function() {
      console.log('in li success');
    });

    li.ajaxComplete(function() {
      console.log('in li complete');
    });

    $.ajax({
      url: this.addUrl,
      data: {album_id: albumId, track_id: this.trackId},
      cache: false,
      global: false,
      ifModified: false,
      'complete': function(data) {
        alert('cool');
        console.log('add track success');
        console.log(resp);
        resp.responseText;
        box.attr('checked', true);
      }
    });
  },

  dropFromAlbum: function(li) {
    var box = li.find('input[type=checkbox]');
    var albumId = li.attr('data-id');

    console.log('in drop track');
    $.ajax({
      type: 'post',
      url: this.dropUrl,
      data: {album_id: albumId, track_id: this.trackId},
      complete: function(resp) {
        console.log('drop track success');
        console.log(resp);

        resp.responseText;
        box.attr('checked', false);
      }
    });
  },

  update: function(trackId) {
    var self = this;
    this.trackId = trackId;

    this.cleanUp();
    db.view(this.trackAlbumsView, {include_docs: true, key: trackId}, function(data) {
      $.each(data.rows, function() {
        self.checkAlbum(this.doc['_id']);
      });
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
  this.input = input;

  this.imgBlock = $('<div></div>', { 'class': 'track_photos'});
  this.input.parent().append(this.imgBlock);
}

PhotosInput.prototype = {
  update: function(track) {
    var self = this; 
    this.trackId = track['_id'];
    this.photos  = track['photos_attachments'];

    this.imgBlock.html('');
    $.each(this.photos, function() {
      if (this.thumbs.small) {
        self.imgBlock.append($('<img />', {src: this.thumbs.small.url}));
      }
    });
  },

  fireOnOpen: function() {
    $(this.input).uploadifySettings('scriptData', {track_id: this.trackId});
  }
}


//----------------------------------------------------------------------
Mp3FileInput = function(input) {
  this.input = input;
  this.fileCont = $('<div></div>');
  this.input.parent().prepend(this.fileCont);
};

Mp3FileInput.prototype = {
  update: function(trackMp3File) {
    this.fileCont.html('');
    var a = $('<a>' + trackMp3File.file_name + '</a>');
    a.attr('href', trackMp3File.url);
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
  var self = $(this);
  var ctl  = new PhotosInput(this);
  this.ctl = ctl; 

  var uploader = new qq.FileUploader({
    element: $(this)[0],
    action: '/admin/audios/upload_photo',
    onComplete: function(id, fileName, responseJSON){
      console.log('onComplete photo upload');
      return true;
    }
  });
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
  var viewUrl = '_design/Album/_view/all';
  var template = "{{#rows}}{{#doc}}<li data-id={{_id}}><input type=checkbox>{{title}}</li>{{/doc}}{{/rows}}"

  db.view(viewUrl, {include_docs: true}, function(data) {
    self.append(Mustache.to_html(template, data));
    self.ctl = new AlbumsInput(self);
  });
}

$.fn.asMp3FileInput = function() {
  var control = buildControlDiv();
  control.hide();
  var ctl = new Mp3FileInput(this);
  this.ctl = ctl;

  control.linkToUpload.click(function(el) {
    this.uploadifySettings('scriptData', {need_update_info: control.isNeedUpdateInfo()});
    this.uploadifyUpload();

    return false;
  });

  this.uploadify({
    uploader:  '/uploadify.swf', 
    script:    '/replace', 
    folder:    '/path/to/uploads-folder', 
    cancelImg: '/images/cancel.png',
    multi:     false,
    auto:      false,
    width: 250,
    height: 100,
    buttonImg: '/images/replace.png',
    buttonText: '',
    fileExt: '*.mp3',
    fileDesc: 'Only *.mp3 allow',
    onSelect: function(event, queueID, fileObj) {
      control.checkBox.attr('checked', false);
      control.show();
    },
    onCancel: function(event, queueID, fileObj) {
      control.hide();
    },
    onComplete: function(event, queueID, fileObj, response, data) {
      var resp = eval('(' + response + ')');
      control.hide();
      linkToDownload.attr('href', resp.url);
      linkToDownload.html(resp.file_name);
      linkToDownload.effect("highlight", {}, 10000);
    },
    onProgress: function(event, queueID, fileObj, data) {
    }
  }); 

  var queue = $('<div>', {'class': 'uploadifyQueue', id: this.attr('id') + 'Queue'});
  this.parent().append(queue);
  this.parent().append(control);
}

function buildControlDiv() {
  var newDiv = $("<div />");
  var checkBox = $("<input type='checkbox' />");
  var label = $("<label />");
  var linkToUpload = $("<a href='#'>Залить</a>");

  label.append(checkBox);
  label.append("зменить теги");
  newDiv.append(label);
  newDiv.append("&nbsp;&nbsp;");
  newDiv.append(linkToUpload);

  newDiv.linkToUpload = linkToUpload;
  newDiv.isNeedUpdateInfo = function() {
    return checkBox.is(':checked'); 
  };

  newDiv.checkBox = checkBox; 

  return newDiv; 
}


$.fn.setSelected = function(value) {
  var option = this.find('option[value=' + value + ']');
  option.attr('selected', 'selected');
}
