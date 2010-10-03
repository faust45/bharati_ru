$.log = console.log;

function typeOf(obj) {
  if (typeof(obj) == 'object') {
    return (obj.length != null ? 'array' : 'object');
  } else {
    return typeof(obj);
  }
}

function range(first, last) {
  var arr = [];

  for(var i=first; i <= last; i=i+1) {
    arr.push(i);
  }

  return arr;
}

function getCurrentYear() {
  return (new Date()).getFullYear();
}

function parseDate(input, format) {
  format = format || 'yyyy-mm-dd'; // default format

  if (input) {
    var parts = input.match(/(\d+)/g), 
        i = 0, fmt = {};
    // extract date-part indexes from the format
    format.replace(/(yyyy|dd|mm)/g, function(part) { fmt[part] = i++; });

    return new Date(parts[fmt['yyyy']], parts[fmt['mm']], parts[fmt['dd']]);
  } else {
    return UnknownDate; 
  }
}

$.fn.setSelected = function(value) {
  var option = this.find('option[value=' + value + ']');
  option.attr('selected', 'selected');
}

$.fn.updateUL = function(ids) {
  var ul = $(this);

  ul.find('li input[type=checkbox]').each(function() {
    $(this).attr('checked', false);
  });

  $.each(ids, function(id) {
    ul.find('li[data-id=' + this + '] input[type=checkbox]').each(function() {
      $(this).attr('checked', true);
    });
  });
}

// Classes
UnknownDate = {
  getDate: function() {
  },

  getMonth: function() {
  },

  getFullYear: function() {
  }
}
