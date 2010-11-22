jQuery(function($){
  $.datepicker.setDefaults({
    dateFormat: 'yy-mm-dd'
  });
});

(function($) {
  var BASE62 = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z", "a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z"];

  Date.prototype.toCouchId = function() {
    var ms = new Date().getTime(), base = 62, res = [];
    ms = parseInt(ms + "00");
    var ost;

    while(ms > 0) {
      ost = parseInt(ms % base);
      ms = parseInt(ms / base);
      res.unshift(BASE62[ost]);
    }

    return res.join('');
  }
})();

//(function($) {
//  $.evently.fn.render.mustachee = function(h, args) {
//    h.mustache = h.mustachee;
//    return $.evently.fn.render.mustache(h, args);
//  };
//})(jQuery);

(function($) {
  $.evently.fn.setup.as_list = function(h, cb, args) {
    console.log('in as_list');
    var el = this, app = $$(el).app, common = App.last_docs.listCommon
      , selectors = $.evently.utils.rfun(el, common, args)
      ;

    $.extend(true, h, common);
    //$.forIn(selectors, function(selector, handlers) {
    //  $(selector, root).evently(handlers, app, args);
    //});
    
    cb()
  };
})(jQuery);


(function($) {
  $.evently.fn.after.as_form = function(h, rendered, args) {
    var render = (h.render || "replace").replace(/\s/g,"")
      , el = this, app = $$(el).app
      , root = (render == "replace") ? el : rendered
      , selectorsFields = $.evently.utils.rfun(el, h.fields, args)
      ;

    
    var fields = [];
    $.forIn(selectorsFields, function(selector, handlers) {
      $(selector, root).evently(handlers, app, args);

      var input;
      $(selector).each(function() {
        if(input = asCustomInput(this)) {
          fields.push(input);
        }
      });
    });

    $(this).find('form')[0].fields = fields;
  };

  function asCustomInput(el) {
    //var el = $(selector)[0];
    if (!el) { return }

    switch(el.tagName) {
      case 'INPUT':
        switch(el.type) {
          case 'text':
          return asTextInput(el);
        }
      case 'SELECT':
        return asSelectInput(el);
      case 'TEXTAREA':
        return asTextInput(el);
    }
  }

  function asTextInput(el) {
    el.ctl = {
      getData: function() {
        var value = $(el).val();
        if ($(el).hasClass('text-array')) {
          var arr = [];
          var raw = value.split('\n');
          $.each(raw, function(i) {
            var el = $.trim(raw[i]);
            if(!isBlank(el)) {
              arr.push(el);
            }
          });

          value = arr;
        }

        return value;
      }
    }

    return el;
  }

  function asSelectInput(el) {
    el.ctl = {
      getData: function() {
        var value = $(el).val();
        return value;
      }
    }

    return el;
  }

})(jQuery);


(function($) {
  $.evently.fn.after.path = function(h, rendered, args) {
    var elem = this;
    console.log('in path plugin');
      //elem.bind(h.name, function() {$.log(elem, name)});
    // todo make pathbinder plugin
    // if (h.path) {
      // elem.pathbinder(name, h.path);
    // }


  };
})(jQuery);

/*
function procAll(elem, events, app) {
  // store the app on the element for later use
  if (app) {$$(elem).app = app;}
  if (typeof events == "string") {
    events = extractEvents(events, app.ddoc);
  }

  forIn(events, function(name, h) {
    eventlyHandler(elem, name, h, args);
  });
  
  return events;
}

function eventlyHandler(elem, name, h, args) {
  if ($.evently.log) {
    elem.bind(name, function() {
      $.log(elem, name);
    });
  }

  if (h.path) {
    elem.pathbinder(name, h.path);
  }

  for (var i=0; i < h.length; i++) {
    eventlyHandler(elem, name, h[i], args);
  }
};
*/

function dbUpdate(app, handler, id, options, fun) {
  $.log('in dbUpdate');
  var path = app.db.uri + app.ddoc._id + "/_update/" + handler + "/" + id + encodeOptions(options);
  $.log(path);

  $.ajax({
    type: 'PUT', 
    url: path,
    success: fun
  });
}

function fetchDocs(ids, fun) {
  var app = App.app;
  var path = app.db.uri + '_all_docs&include_docs=true';

  $.ajax({
    type: 'POST', 
    contentType: 'application/json',
    data: {"keys": ["id1", "id2"]},
    url: path,
    success: fun
  });
}



function encodeOptions(options) {
  var buf = [];
  if (typeof(options) === "object" && options !== null) {
    for (var name in options) {
      if ($.inArray(name, ["error", "success", "beforeSuccess", "ajaxStart"]) >= 0)
        continue;
      var value = options[name];
      if ($.inArray(name, ["key", "startkey", "endkey"]) >= 0) {
        value = toJSON(value);
      }
      buf.push(encodeURIComponent(name) + "=" + encodeURIComponent(value));
    }
  }
  return buf.length ? "?" + buf.join("&") : "";
}

