function(resp, e, params) {
  var viewParams = {
    items: resp.rows, 
    link: params.view,
    title: title
  };

  var events = $$(this).evently[params.view];
  if (events) {
    attrTitle = events.title;
    viewParams.listClass = events.listClass;
  }

  function title() {
    return this[attrTitle];
  }

  return viewParams;
}
