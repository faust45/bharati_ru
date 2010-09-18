//--------------------------------------------------------------
//Initialization

$(document).ready(function() {
  $('ul.tracks li a').behavior(TrackEditBehavior);
});

function TrackEditBehavior(element) {
  var el = $(element);
  var id = el.attr('data-id');

  el.click(function() {
    EditForm.editTrack(id);
    return false;
  });
}

