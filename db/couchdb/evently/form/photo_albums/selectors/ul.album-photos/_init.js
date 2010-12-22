function(e) {
  $.log('become sorteble', this);
  var el = $(this);


  /*
  $(this).sortable({
    containment: 'document',
    items: 'li',
    dropOnEmpty: true,
    out: function(event, ui) { $.log('out') },
    remove: function(event, ui) { },
    over: function(event, ui) { $.log('over in') },
    receive: function(event, ui) { $.log('recive in') },
    helper:'clone',
    cursor: 'move',
    scope: 'item-box',
    opacity: 100,
    appendTo: '.wrap',
    zIndex:  20000,
    connectWith: '.item-box',

    update: function(event, ui) { 
      el.trigger('formChanged');
    }
  });
*/

}
