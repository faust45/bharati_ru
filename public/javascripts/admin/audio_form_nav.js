//--------------------------------------------------------------
//Initialization

$(document).ready(function() {
  var links = $('#context_nav a');
  var tabs  = $('.tab');

  links.each(function(i) {
    $(this).click(function() {
      tabs.each(function() {
        $(this).removeClass('active');
      });

      links.each(function() {
        $(this).parent().removeClass('active');
      });

      $(tabs[i]).addClass('active');
      $(this).parent().addClass('active');

      return false;
    });
  });
});


//--------------------------------------------------------------


