//--------------------------------------------------------------
//Initialization

$(document).ready(function() {
  var albums = $('#albums_list ul a').behavior(AlbumDirBehavior);
});

//--------------------------------------------------------------


function AlbumDirBehavior(element, config) {
  var viewUrl  = '_design/Audio/_view/by_album';
  var template = "<ul class='tracks'> {{#rows}}<li>{{#doc}}<span class='ico'><a data-id='{{_id}}'>{{#trim}}{{title}}{{/trim}}{{/doc}}</a></span></li>{{/rows}} </ul>";
  var trim = function() {
    return function(text, render) {
      return render(this.title.substring(0, 40));
    }
  };

  var element = $(element);
  var id = element.attr('data-id');
  var tracks  = $('#tracks_list');

  element.click(function() {
    db.view(viewUrl, {include_docs: true, startkey: [id], endkey: [id, {}]}, function(data) {
      data.trim = trim;
      var html = Mustache.to_html(template, data);
      tracks.html(html);
    });

    return false;
  });
}

function pre() {
  return function(text, render) {
    return "<b> Stuff" + render(text) + '</b>';
  }
}
