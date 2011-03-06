(function ($) {
  $(document).ready(function() {
    $('.panel a.login').click(function() {
      $('#pop').show();
      return false;
    });


    if($('.panel a.user-nav').exists()) {
      Panel($('.panel'));
    }
  });
})(jQuery);

Panel = function(panel) {
  var state = 'close',
      links = panel.find('.links');

  $("#logout-link").bind("ajax:success", function(e, data) {
    window.location.reload();
  });
  
  panel.mouseover(function() {
    if (state == 'close') {
      links.removeClass('none');
      state = 'open';
    }
  });

  panel.mouseleave(function() {
    if (state == 'open') {
      links.addClass('none');
      state = 'close';
    }
  });
}
