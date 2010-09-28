TitleInput = {
  create: function() {
    var self = this;
    var node = document.createDocumentFragment();
    var input = $('<input>', {type: 'text', size: 25});
    node.appendChild(input[0]);

    input.keypress(function() {
      $(node).trigger('field.changed');
    });

    node.ctl = {
      getData: function() {
        return input.val();
      },

      refresh: function(doc) {
        input.val(doc.title);
      }
    };

    return node;
  }
}


//--------------------------------------------------------------
PhotoInput = {
  create: function() {
    var node = document.createDocumentFragment();
    var img = $('<img>');
    var div = $('<div>');

    var ctl = {
      refresh: function(doc) {
        this.albumID = doc['_id'];
        if (doc.cover_attachments) {
          var cover = doc.cover_attachments[0];
          console.log(this.coverUrl = cover.thumbs.small.url);

          if (cover) {
            this.coverUrl = cover.thumbs.small.url;
          }
        }

        img.attr('src', this.coverUrl);
      },

      getData: function() {}
    };

    var uploader = new qq.FileUploader({
      element: div[0],
      action: '/admin/albums/upload/cover',
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
    node.appendChild(img[0]);

    node.ctl = ctl;

    return node;
  }
}


$.fn.asPhotosInput = function() {
  this.ctl = new PhotosInput(this); 
};

$.fn.asTagsInput = function() {
  this.ctl = new TagsInput(this);
};

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
      getData: function() {
        return this.getSelected();
      },

      getSelected: function() {
        return selectList.val();
      },

      refresh: function(doc) {
        selectList.setSelected(doc['_id']);
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

$.fn.asDateInput = function() {
  this.ctl = new DateSelect(this);
}

$.fn.asAlbumsInput = function() {
  var self = this;
  var template = "{{#rows}}{{#doc}}<li data-id={{_id}}><input type=checkbox>{{title}}<span class='response'></span></li>{{/doc}}{{/rows}}"

  Model.Album.all(function(data) {
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
