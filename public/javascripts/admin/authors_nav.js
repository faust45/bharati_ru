$(document).ready(function() {
  $('#authors_nav li').behavior(AuthorsNavBehavior);
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
