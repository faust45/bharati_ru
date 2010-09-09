//--------------------------------------------------------------
//Initialization

$(document).ready(function() {
  $('#tracks li').behavior(DropFromAlbumBehavior)
  $('#tracks').sortable({});
});


//--------------------------------------------------------------

function DropFromAlbumBehavior(element, config) {
  console.log('apply log');

  var element = $(element);
  var linkToDrop = element.find('a.drop');
  var linkToEdit = element.find('a.edit');
  var urlToDrop = linkToDrop.attr('href');
  linkToDrop.hide();

  element.prepend("<img class='handle' src='/images/arrow.png'>");
  element.mouseover(function() {
    linkToDrop.show();
    linkToEdit.show();
  });

  element.mouseout(function() {
    linkToDrop.hide();
    linkToEdit.hide();
  });


  linkToDrop.click(function() {
    console.log('stuff');
    return false;
  });
}
