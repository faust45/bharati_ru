//--------------------------------------------------------------
//Initialization

$(document).ready(function() {
  $('#tracks li').behavior(EditAlbumBehavior)
  $('#tracks').sortable({});
});


//--------------------------------------------------------------

function EditAlbumBehavior(element, config) {
  console.log('apply log');

  var element = $(element);
  var linkToDrop = element.find('a.drop');
  var editBlock = element.find('div.edit_block');
  //var linkToEdit = element.find('a.edit');
  var urlToDrop = linkToDrop.attr('href');
  editBlock.hide(); 

  element.prepend("<img class='handle' src='/images/arrow.png'>");

  element.mouseover(function() {
    editBlock.show(); 
  });

  element.mouseout(function() {
    editBlock.hide(); 
  });


  linkToDrop.click(function() {
    console.log('stuff');
    return false;
  });
}
