// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
//
// // Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

jQuery.log = function(message) {
  console.log(message);
};


jQuery(function ($) {
  $.mustache = function(template, view, partials) {
    return Mustache.to_html(template, view, partials);
  };
});

function ToggleBehavior(element, config) {
  element = $(element);

  element.mouseover(function() {
    element.addClass('bm-active');
  });

  element.mouseout(function() {
    element.removeClass('bm-active');
  });
}
