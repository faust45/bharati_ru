//--------------------------------------------------------------
//Initialization

$(document).ready(function() {
  var selectByAlbum = $('#by_album_id');
  var selectByYear  = $('#date_year');
  var form = $('#search');

  selectByAlbum.change(function(item) {
    var selected = $(this).find("option:selected");
    form.submit();
  });

  selectByYear.change(function(item) {
    var selected = $(this).find("option:selected");
    form.submit();
  });
});


