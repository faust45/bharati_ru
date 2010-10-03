View = {};

AlbumsInput = {
  addURL:  '/admin/albums/add_track',
  dropURL: '/admin/albums/drop_track',
  template: "{{#rows}}{{#doc}}<li data-id={{_id}}><input type=checkbox>{{title}}<span class='response'></span></li>{{/doc}}{{/rows}}",

  create: function() {
    var self = this;
    var ul = $('<ul>', {class: 'albums'});

    Model.Album.all(function(data) {
      ul.html('');
      ul.append(Mustache.to_html(self.template, data));

      ul.find('li').each(function() {
        var li = $(this);
        var box = li.find('input[type=checkbox]');
        var response = li.find('span.response');
        var albumID = li.attr('data-id');
    
        li.albumID = albumID;
        li.box = box;
        li.response = response;
    
        li.click(function() {
          if (box.is(':checked')) {
            self.dropFromAlbum(li, ctl.trackID);
          } else {
            self.addToAlbum(li, ctl.trackID);
          };
        });
      });
    });

    var ctl = {
      refresh: function(docID) {
        this.trackID = docID;

        Model.Album.trackAlbums(docID, function(data) {
          ul.updateUL(data.getIDs());
        });
      },

      getData: function() {}
    };

    ul.ctl = ctl;
    return ul;
  },

  request: function(url, albumID, trackID, fun) {
    $.ajax({
      url: url,
      data: {album_id: albumID, track_id: trackID},
      cache: false,
      global: false,
      ifModified: false,
      complete: fun 
    });
  },

  addToAlbum: function(li, trackID) {
    this.request(this.addURL, li.albumID, trackID, function() {
       li.box.attr('checked', true);
       li.response.html('added');
       li.response.show();
       li.response.css('color', 'green');
       li.response.fadeOut(3000);
    });
  },

  dropFromAlbum: function(li, trackID) {
    this.request(this.dropURL, li.albumID,trackID, function() {
       li.box.attr('checked', false);
       li.response.html('removed');
       li.response.show();
       li.response.css('color', 'red');
       li.response.fadeOut(3000);
    });
  }
  
}


//--------------------------------------------------------------
SortType = {
  create: function() {
    var sortType = $('<label class="sort-type">Hand sort</label>');
    var checkbox = $('<input type="checkbox">');
    sortType.prepend(checkbox);

    checkbox.change(function() {
      sortType.trigger('field.changed');
    });

    var ctl = {
      refresh: function(docID, value) {
        checkbox.attr('checked', value == 'true' ? true : false);
      },

      getData: function() {
        return checkbox.is(':checked');
      }
    };

    sortType.ctl = ctl;
    return sortType;
  }
}


//--------------------------------------------------------------
SortTracks = {
  template: "{{#rows}}{{#doc}}<li><img src='/images/arrow.png' /><input type='hidden' value={{_id}}> {{title}}</li>{{/doc}}{{/rows}}",

  create: function() {
    var self = this;
    var ul = $('<ul>', {'class': 'sort-tracks'});

    var ctl = {
      refresh: function(docID, values) {
        Model.Album.tracks(docID, function(data) {
          ul.html(Mustache.to_html(self.template, data));
          ul.sortable({
            update: function(event, ui) { 
              ul.trigger('field.changed');
            }
          });
        });
      },

      getData: function() {
        var tracks = [];

        ul.find('input').each(function() {
          tracks.push($(this).val());
        });

        return tracks;
      }
    };

    ul.ctl = ctl;
    return ul;
  }
}


//--------------------------------------------------------------
StringInput = {
  create: function() {
    return SimpleInput.create('input', {type: 'text', size: 25});
  }
}


//--------------------------------------------------------------
SimpleInput = {
  create: function(type, options) {
    var input = $('<' + type + '>', options);

    input.keypress(function() {
      input.trigger('field.changed');
    });

    input.ctl = {
      getData: function() {
        return input.val();
      },

      refresh: function(docID, value) {
        input.val(value);
      }
    };

    return input;
  }
}




//--------------------------------------------------------------
PhotoInput = {
  create: function() {
    var node = document.createDocumentFragment();
    var imgBlock = $('<div>');
    var div = $('<div>');

    var ctl = {
      refresh: function(docID, values) {
        this.albumID = docID;
        if (values) {
          var cover = values[0];
          if (cover) {
            this.coverUrl = cover.thumbs.small.url;

            this.coverUrl = cover.thumbs.small.url;
            var photo = $('<img />', {src: this.coverUrl + '?' + Math.floor(Math.random()*100)});
            imgBlock.html(photo);
          }
        }
      },

      getData: function() {}
    };

    var uploader = new qq.FileUploader({
      element: div[0],
      action: '/admin/albums/upload/cover',
      multiple: false,
      allowedExtensions: ['jpg', 'jpeg', 'png', 'gif'],
      onSubmit: function(id, fileName) {
        uploader.setParams({
          album_id: ctl.albumID
        });
      },
      onComplete: function(id, fileName, responseJSON) {
        if (responseJSON.doc) {
          ctl.refresh(responseJSON.doc)
        }
      }
    });

    node.appendChild(div[0]);
    node.appendChild(imgBlock[0]);

    node.ctl = ctl;

    return node;
  }
}


$.fn.asPhotosInput = function() {
  this.ctl = new PhotosInput(this); 
};


//--------------------------------------------------------------
TagsInput = {
  create: function() {
    var self = this;
    var node = document.createDocumentFragment();

    var ico        = $('<img>', {src: '/images/tags.png'});
    var tagsCont   = $('<div>', {'class': 'tags'});
    var inputField = $('<input>', {type: 'text', size: '25'});
    var addImg     = $('<img>', {'class': 'add-button', src: '/images/add-icon.png'});
    var linkToAdd  = $('<a>', {href: ''}).append(addImg); 
  
    tagsCont.append(ico);
    node.appendChild(tagsCont[0]);
    node.appendChild(inputField[0]);
    node.appendChild(linkToAdd[0]);
  
    linkToAdd.click(function() {
      Tag.addTo(tagsCont, inputField.val());
      return false;
    });

    tagsCont.bind('tags.added tags.removed', function() {
      $(node).trigger('field.changed');
    });

    var ctl = {
      refresh: function(docID, values) {
        tagsCont.html(ico);

        if(values) {
          Tag.bulkAddTo(tagsCont, values);
        }
      },

      getData: function() {
        var tags = [];
        tagsCont.find('input').each(function() {
          tags.push($(this).val());
        });

        return tags;
      }
    };

    node.ctl = ctl;
    return node;
  }
}


//--------------------------------------------------------------
Tag = {
  bulkAddTo: function(tagsCont, tags) {
    var self = this;
    $.each(tags, function() {
      self.addTo(tagsCont, this, false);
    });
  },

  addTo: function(tagsCont, value, genEvent) {
    if (genEvent == null) {
      genEvent = true;
    }

    var self = this;
    var existsTag = this.getTag(tagsCont, value);

    if (!existsTag) {
      var label = $('<label>' + value + '</label>');
      var checkbox = $('<input>', {type: 'checkbox', value: value});
      checkbox.attr('checked', true);

      label.prepend(checkbox);
      label.click(function() { 
        $(this).remove();
        tagsCont.trigger('tags.removed');
      });

      tagsCont.append(label);
      if (genEvent) {
        tagsCont.trigger('tags.added');
      }
    } else {
      existsTag.effect("highlight", {}, 3000);
    }
  },

  getTag: function(tagsCont, value) {
    var checkbox = tagsCont.find('input[value=' + value + ']');

    if(0 < checkbox.size()) {
      return checkbox.parent();
    }
  }
}


//--------------------------------------------------------------
AuthorInput = {
  template: "{{#rows}}{{#doc}}<option value={{_id}}>{{display_name}}</option>{{/doc}}{{/rows}}",
  data: null,

  create: function() {
    var self = this;

    var selectList = $('<select>');
    this.addDataToSelect(selectList);
  
    selectList.change(function() {
      $(selectList).trigger('field.changed');
    });

    selectList.ctl = {
      refresh: function(docID, value) {
        selectList.setSelected(value);
      },

      getData: function() {
        return this.getSelected();
      },

      getSelected: function() {
        return selectList.val();
      }
    };

    return selectList;
  },

  addDataToSelect: function(selectList) {
    var self = this;

    selectList.append($('<option>Select Author</option>'));
    if (!this.data) {
      Model.Author.all(function(data) {
        self.data = data;
        selectList.append(Mustache.to_html(self.template, data));
      });
    } else {
      selectList.append(Mustache.to_html(this.template, this.data));
    }
  }
};


//--------------------------------------------------------------
DateInput = {
  create: function() {
    var input = this.createInput();

    var day   = $(input[0]);
    var month = $(input[1]);
    var year  = $(input[2]);

    var funRunEven = function() { input.trigger('field.changed'); };
    day.change(funRunEven); 
    month.change(funRunEven)
    year.change(funRunEven);

    input.ctl = {
      refresh: function(docID, value) {
        var date = parseDate(value);
  
        this.currentDate = date;
        day.setSelected(date.getDate());  
        month.setSelected(date.getMonth());  
        year.setSelected(date.getFullYear());  
      },

      getData: function() {
        return (year.val() + '-' + month.val() + '-' + day.val());
      }
    }

    return input;
  }, 

  createInput: function(input) {
    var input = $('<select></select><select></select><select></select>');
    var template = "<option></option>{{#range}}<option value={{.}}>{{.}}</option>{{/range}}";
    var days   = range(1, 31);
    var months = range(1, 12);
    var years  = range(1900, getCurrentYear());

    $.each([days, months, years], function(i) {
      var html = Mustache.to_html(template, {range: this});
      $(input[i]).append(html);
    });

    return input;
  }
}


//--------------------------------------------------------------
$.fn.asMp3FileInput = function() {
  this.ctl = new Mp3FileInput(this);
}


