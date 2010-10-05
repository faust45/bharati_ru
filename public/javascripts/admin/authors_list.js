$(document).ready(function() {
  $('#authors-list').append(View.List());
});


View.List = function () {
  var current, currentDocID;
  var template = '<li data-id={{_id}}> <a href="">{{display_name}}</a> <img class="del" src="/images/del.png" /></li>';
  var ul = $('<ul>');

  //private
  var render = function(data) {
    ul.mustache(template, data);
    ul.find('li').each(function () {
      var li = $(this);
      var id = li.attr('data-id');
      var imgDel = li.find('img.del');

      imgDel.click(function() { destroyAuthor(li, id) });
      li.click(setCurrent);
      li.mouseover(mouseOver);
      li.mouseout(mouseOut);
    });
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

  var mouseOver = function(e) {
    $(this).addClass('mouseover');
  },

  mouseOut = function(e) {
    $(this).removeClass('mouseover');
  },

  destroyAuthor = function(li, id) {
    if (confirm('Чувак может не стоит удалять?')) {
      $.ajax({
        url: '/admin/authors/destroy',
        data: {id: id},
        success: function(resp) {
          li.effect("highlight", {}, 3000);
          li.fadeOut(3000);
        }
      });
    }
  };

  Model.Author.all(render);

  $(document).bind('addNewAuthor', function(e, track) {
  });

  return ul;
};
