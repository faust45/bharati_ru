function() {
  $.log('click faq');
  var album = new AlbumPublication(li.attr('data-id'));
  var li = this;

  album.add(EditDocForm.docId(), function() {
    li.trigger('added');
  });

  return false;
}
