

FormBase = {
  cont: null,
  buttonSave: null,
  dataSourceMap: {
    authorID:   'author_id',
    recordDate: 'record_date',
    sortType:   'is_hand_sort',
    cover:     'cover_attachments',
    mainPhoto: 'main_photo_attachments',
    photos:    'photos_attachments',
    bookmarks: 'bookmarks_raw',
    extracts: 'extracts_raw'
  },

  dataSourceMapFun: {
    bookmarks: function(doc) {
      var text = '';
      $.each(doc.bookmarks, function() {
        text = text + this.str_time + '  ' + this.name + '\n';
      });

      return text;
    },

    extracts: function(doc) {
      if (doc.extracts) {
        return doc.extracts.join('\n\n');
      }
    }
  },

  refresh: function() {
    this.dataSaved();
    this.refreshFields()
  },

  html: function() {
    return this.buildForm();
  },

  append: function(blocks) {
    var cont = this.cont;

    $.each(blocks, function() {
      cont.append(this.html());
    });
  },

  refreshFields: function() {
    var self = this;

    $.each(this.fields, function(k, v) {
      v.ctl.refresh(self.doc['_id'], self.getDocValue(k) || '');
    });
  },

  setSaveButton: function(el) {
    var self = this;
    this.buttonSave = el;

    el.click(function() {
      self.saveData();
      return false;
    });
  },

  getData: function() {
    var self = this;
    var data = {
      id: this.getID()
    };         

    $.each(this.fields, function(k, v) {
      var value = v.ctl.getData();

      if (value != null) {
        var param = self.dataSourceMap[k] || k;
        var paramName = self.paramsSpace + '[' + param + ']';
        data[paramName] = value;
      }
    });

    return data;
  },

  saveData: function() {
    var self = this;

    var url = this.doc._id ? this.saveURL : this.newURL;
    $.ajax({
      url: url,
      type: 'post',
      data: this.getData(),
      success: function(resp) {
        self.dataSaved();
      }
    });
  },

  listenChanges: function() {
    var self = this;

    $(this).bind('form.changed', function() {
      self.dataChanged();
    });

    $.each(this.fields, function(k, v) {
      $(v).bind('field.changed', function() {
        $(self).trigger('form.changed');
      });
    });
  },

  dataChanged: function() {
    var pathSave  = '/images/save.png';
    this.buttonSave.attr('src', pathSave);
  },

  dataSaved: function() {
    var pathSaved = '/images/saved.png';
    this.buttonSave.attr('src', pathSaved);
  },

  getDocValue: function(attrName) {
   var fun = this.dataSourceMapFun[attrName];
   var docAttrName = this.dataSourceMap[attrName] || attrName;

   if (fun) {
     return fun(this.doc);
   } else {
     return this.doc[docAttrName];
   }
  },

  getID: function() {
    return this.doc['_id'];
  }
};


//----------------------------------------------------------------------
function FieldSet(fieldsHash, names, options) {
  var fields = [];
  this.options = options || {};

  $.each(names, function() {
    fields.push(fieldsHash[this]);
  });

  this.fields = fields;
};

FieldSet.prototype = {
  fields: null,

  html: function() {
    var cssClass = this.options.tab == false ? '' : 'cnt';
    var wrap = $('<div>', {'class': cssClass});

    $.each(this.fields, function() {
      var div = $('<div>', {'class': 'input'}),
          label = $('<label>' + $(this).attr('data-label') + '</label>');

      div.append(label);
      div.append('<br />');
      div.append(this);
      wrap.append(div);
    });

    return wrap;
  }
};


