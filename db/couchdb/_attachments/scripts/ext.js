//(function($) {
//  $.evently.fn.render.mustachee = function(h, args) {
//    h.mustache = h.mustachee;
//    return $.evently.fn.render.mustache(h, args);
//  };
//})(jQuery);

(function($) {
  $.evently.fn.after.as_form = function(h, rendered, args) {
    var render = (h.render || "replace").replace(/\s/g,"")
      , root = (render == "replace") ? el : rendered
      , el = this, app = $$(el).app
      , selectors = $.evently.utils.rfun(el, h.as_form, args)
      ;

    h.as_form.fields = [];
    $.forIn(selectors, function(selector, handlers) {
      $(selector, root).evently(handlers, app, args);

      var input;
      $(selector).each(function() {
        if(input = asCustomInput(this)) {
          h.as_form.fields.push(input);
        }
      });

      $$(selector).formEdit = h.as_form;
    });
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
    }
  }

  function asTextInput(el) {
    el.ctl = {
      getData: function() {
        return $(el).val();
      }
    }

    return el;
  }

  function asSelectInput(el) {
    el.ctl = {
      getData: function() {
        return $(el).find('option[selected=true]').attr('value');
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
