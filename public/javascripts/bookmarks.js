$(document).ready(function() {
  $('div.playList li').behavior(BookmarkBehavior);
});


function BookmarkBehavior(li, config) {
  var li = $(li);
  var link = li.find('a');
  var time = link.attr('data-time');

  li.click(function() {
    Player.gotoTime(time);
    return false;
  });
};
