function() {
  var dropzone = $(this),
      albumId = dropzone.attr('data-id'); 

      /*$(this).droppable({
        dropOnEmpty: true,
        scope: 'item-box',
        receive: function(event, ui) { 
          $.log('item recive');
          ui.item.remove() 
        },
      });
      */

      $(this).draggable({
        helper:'clone',
        containment: 'document',
        opacity: 100,
        zIndex:  20000,
        appendTo: '.wrap',
        cursor: 'move',
        scope: 'sub-albums'
      });

/*
  dropzone.bind("dragover", function(e) {
    var el = e.originalEvent.dataTransfer.getData('text/html');
    $.log(e, el)
    //if($(el).hasClass('photo')) {
      active(); e.preventDefault();
    //}
  }, true);
  dropzone.bind("dragleave", function(e) {
    var el = e.originalEvent.dataTransfer.getData('text/html');
    //if($(el).hasClass('photo')) {
      deActive(); e.preventDefault();
    //}
  }, true);
  dropzone.bind("drop", function(e) {
    deActive();
    var id = e.originalEvent.dataTransfer.getData('text/plain');
    var el = e.originalEvent.dataTransfer.getData('text/html');

    $.log('try free');
    if(el.hasClass('photo')) {
      dbUpdate(App.app, 'add_to_album', albumId, {field: 'photos', item: id}, function() { })
    }

    e.preventDefault();
  }, true);
*/
  function active() {
    dropzone.addClass('dropHere');
  }

  function deActive() {
    dropzone.removeClass('dropHere');
  }
}
