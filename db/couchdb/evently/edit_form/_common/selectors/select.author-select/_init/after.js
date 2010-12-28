function(data, e, doc) {
  $(this).find('option[value=' + doc.author_id + ']').attr('selected', true);
}
