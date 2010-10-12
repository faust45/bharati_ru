$(document).ready(function() {
  $('#authors_nav li').behavior(AuthorsNavBehavior);
  $('#audios_all_authors').click(function() {
    Model.Author.current = null;
    $(document).trigger('currentAuthorChanged', [null]);
    return false;
  });
});

function AuthorsNavBehavior(el) {
  el = $(el);
  var id = el.attr('data-id');

  el.click(function() {
    Model.Author.current = id;
    $(document).trigger('currentAuthorChanged', [id]);
    return false;
  });
}
