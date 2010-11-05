$(document).ready(function() {
  $("#popup_block").hover(function() {
    $("#popup_block_in").stop(true, true).animate({opacity: "show"}, "slow");
  }, function() {
    $("#popup_block_in").animate({opacity: "hide"}, "fast");
  });
});
