function(data, e, ev, doc) {
  $(this).find('option[value=' + doc.author_id + ']').attr('selected', true);
}
