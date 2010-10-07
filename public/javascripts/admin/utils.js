$.log = function () { console.log(arguments) };

function genRand() {
  return Math.floor(Math.random()*100);
}

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

$.fn.mustache = function(template, data, type) {
  if (typeOf(data.rows) == 'array') {
    template = '{{#rows}}{{#doc}}' + template + '{{/doc}}{{/rows}}';
  } else {
    template = '{{#doc}}' + template + '{{/doc}}';
    data = {doc: data};
  }

  var html = Mustache.to_html(template, data);
  switch (type) {
    case 'append':
      $(this).append(html);
      break;
    case 'prepend':
      $(this).prepend(html);
      break;
    case 'replace':
      $(this).html(html);
      break;
    default:
      $(this).html(html);
  };
}

$.fn.blindToggle = function(speed, easing, callback) {
  var v = parseInt(this.css('marginLeft'));
  var left = (v == 0 ? 300 : 0);
  return this.animate({marginLeft: left}, speed, easing, callback);  
};


// Classes
UnknownDate = {
  getDate: function() {
  },

  getMonth: function() {
  },

  getFullYear: function() {
  }
}
