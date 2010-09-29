

FormBase = {
  fields: {},
  cont: null,
  buttonSave: null,

  append: function(blocks) {
    var cont = this.cont;

    $.each(blocks, function() {
      cont.append(this.html());
    });
  },

  refreshFields: function() {
    var album = this.album;
    $.each(this.fields, function(k, v) {
      v.ctl.refresh(album);
    });
  },

  setSaveButton: function(el) {
    var self = this;
    this.buttonSave = el;

    el.click(function() {
      self.saveData();
    });
  },

  getData: function() {
    var self = this;
    var data = {};         

    data['id'] = this.getID();
    $.each(this.fields, function(k, v) {
      var value = v.ctl.getData();
      if (value != null) {
        var param = self.paramsMap[k] || k;
        var paramName = 'album[' + param + ']';
        data[paramName] = value;
      }
    });

    return data;
  },

  saveData: function() {
    var self = this;

    $.ajax({
      url: this.saveURL,
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

};


//----------------------------------------------------------------------
function FieldSet(fieldsHash, names) {
  var fields = [];

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


