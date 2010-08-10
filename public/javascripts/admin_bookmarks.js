$(document).ready(function() {
  $('.list_edit').each(function() {
    new BookmarkControl(this);
  });
});


BookmarkControl = function(container) {
  var container = $(container);

  this.ul = container.find('.bookmarks > ul');
  this.addButton = container.find('.add_button');
  this.inputTitle = container.find('input[name=title]');
  this.inputTime  = container.find('input[name=time]');

  var self = this;
  this.addButton.click(function() {
    new Bookmark(self);
  });

  this.ul.children().each(function() {
    var c = $(this).attr('data-time');
    $(this).append('&nbsp;&nbsp;&nbsp&nbsp;'+ c +'&nbsp;&nbsp');
    $(this).append('<a><img src="/images/deletered.png"/></a>')
  });
}

BookmarkControl.prototype = {
}

Bookmark = function(cont) {
  console.log('try some impossible');
  console.log(cont.ul);
  var html = '<li>{{title}} {{time}}</li>';
  html = html.replace('{{title}}', cont.inputTitle.val());
  html = html.replace('{{time}}', cont.inputTime.val());

  cont.ul.append(html);
}
