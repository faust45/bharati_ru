(function ($) {
  $(document).ready(function() {
    $('#pop').dialog({ modal: true, position: 'center, top', autoOpen: false,
                       open: function() { $("#my-wrap").addClass('cool'); },
                       close: function() {    $("#my-wrap").removeClass('cool');}
                     });
    $("#fuzz").css("height", $(window).height());

    $(window).bind("resize", function(){
      $("#fuzz").css("height", $(window).height());
    });

   $(window).scroll(function(e){
      $("#fuzz").css("height", $(window).height());
    });

    $('.panel a.login').click(function() {
      $('#pop').dialog('open');
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
