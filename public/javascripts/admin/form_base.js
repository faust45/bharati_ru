
FormBase = {
  fields: {},
  cont: null,

  append: function(blocks) {
    var cont = this.cont;

    $.each(blocks, function() {
      cont.append(this.html());
    });
  },

  refreshFields: function() {
    var album = this.album;
    $.each(this.fields, function(k, v) {
      console.log(v);
      v.ctl.refresh(album);
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
  }
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


