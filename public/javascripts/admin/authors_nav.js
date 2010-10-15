$(document).ready(function() {
  $('#authors_nav').asAuthorsNav();
  $('#audios_all_authors').click(function() {
    Model.Author.current = null;
    $('#authors_nav').find('li.current').removeClass('current');
    $(document).trigger('currentAuthorChanged', [null]);
    return false;
  });
});

$.fn.asAuthorsNav = function () {
  var ul = $(this);
  ul.find('li').each(function() {
    var li = $(this);
    var id = li.attr('data-id');

    var setCurrent = function() {
      Model.Author.current = id;
      ul.find('li.current').removeClass('current');
      li.addClass('current');
      $(document).trigger('currentAuthorChanged', [id]);
    };

    li.click(function() {
      setCurrent();
      return false;
    });
  });
}
