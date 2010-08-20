//--------------------------------------------------------------
//Initialization


$(document).ready(function() {
  Albums.all().behavior(AlbumsBehavior)
});


//--------------------------------------------------------------

function AlbumsBehavior(element, config) {
  var element = $(element);

  var elClass = element.attr('class');
  var title   = element.find('span').html();
  var img     = element.find('a');
  var addUrl = element.attr('data-add-url');
  var delUrl = element.attr('data-del-url');

  var checkbox = $('<input type=checkbox>');
  var label    = $('<label>');

  var isChecked = (elClass == 'selected');
  if (isChecked) {
    checkbox.attr('checked', true);
  }

  label.append(checkbox);
  label.append(title);
  element.html(label);
  element.append(img);

  label.click(function() {
    var isChecked = checkbox.attr('checked');

    if (isChecked) {
      $.ajax({
        type: 'post',
        url: delUrl, 
        complete: function(resp) {
          resp.responseText;
          checkbox.attr('checked', false);
        }
      });
    } else {
      $.ajax({
        type: 'post',
        url: addUrl, 
        complete: function(resp) {
          resp.responseText;
          checkbox.attr('checked', true);
        }
      });
    }

    return false;
  });
}

Albums = {}

Albums.all = function() {
  return $('div.input > ul.albums > li');
}
