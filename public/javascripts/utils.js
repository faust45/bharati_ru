(function($){  
  function render(html, params) {
    $.each(params, function(k, v) {
      html = html.replace('{{'+ k +'}}', v);
    });

    return $(html);
  }

  $.fn.render = function() {
    this.append(render.apply(this, arguments));
  }

  $.replaceWith = function(str, params) {
    $.each(params, function(k, v) {
      if (v == undefined) {
        v = ''
      }

      str = str.replace('{{'+ k +'}}', v);
    });

    return str;
  }
})(jQuery); 
