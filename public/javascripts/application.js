// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
//
// // Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

jQuery.log = function() {
  console.log.apply(this, arguments);
};


(function ($) {
  $.mustache = function(template, view, partials) {
    return Mustache.to_html(template, view, partials);
  };

  $.fn.exists = function() {
    return this.length > 0;
  }
})(jQuery);

function ToggleBehavior(element, config) {
  element = $(element);

  element.mouseover(function() {
    element.addClass('bm-active');
  });

  element.mouseout(function() {
    element.removeClass('bm-active');
  });
}
