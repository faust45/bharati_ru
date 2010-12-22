function(resp, e, params) {
  var items = resp.rows, 
      doc = {_id: 'unbind', title: 'Непревязанные'};

  items.unshift({doc: doc});

  return {items: items, link: params.view};
}

