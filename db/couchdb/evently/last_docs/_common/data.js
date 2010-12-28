function(resp, e, params) {
  var events = $$(this).evently[params.view];
  var attrTitle = events && events.title;

  function title() {
    return this[attrTitle];
  }

  return {items: resp.rows, link: params.view, title: title};
}
