$(document).ready(function() {
  $('#authors-list').append(View.List());
});


View.List = function () {
  var current, currentDocID;
  var template = '<li data-id={{_id}}> <a href="">{{display_name}}</a> </li>';
  var ul = $('<ul>');

  //private
  var render = function(data) {
    ul.mustache(template, data);
    ul.find('li').click(setCurrent);
  };

  var setCurrent = function(e) {
    var li = $(this);
    var id = li.attr('data-id');
    if (current) {
      current.removeClass('current');
    }

    current = li;
    currentDocID = id;
    current.addClass('current');

    $(document).trigger('currentAuthorChanged', [id]);
    return false;
  };

  Model.Author.all(render);

  $(document).bind('addNewAuthor', function(e, track) {
  });

  return ul;
};
