AudioBook = function(book) {
  var add = function(sourceId, fileName, tags) {
    //What if tags blank?
    tags = tags || {};
    title =  tags.title ? tags.title[0] : fileName;

    var track = {
      _id: (new Date()).toCouchId(),
      source: {doc_id: sourceId, file_name: fileName},
      type: "AudioBookTrack", 
      duration: tags.duration,
      title: title
    };

    DocsStore.saveDoc(track, {success: addToBook});
  };

  function addToBook(track) {
    dbUpdate(DocsStore, 'global', 'add_to_album', book._id, {field: 'tracks', item: track.id}, function() { }, true);
  }


  return {
    add: add
  };
}


MyApp = {
  init: function() {
  }
}

$.fn.formTabs = function() {
  var tabs = $('form').find('div.cnt');
  var ul = $(this).find('li');

  ul.each(function(i) {
    var li = $(this);
    var a = li.find('a');

    li.click(function() {
      ul.removeClass('active');
      li.addClass('active');
      tabs.removeClass('active');
      $(tabs[i]).addClass('active');

      return false;
    })
  });
}

$.fn.tabs = function() {
  var tabs = $('form').find('div.cnt');
  var ul = $(this).find('li');

  ul.each(function(i) {
    var li = $(this);
    var a = li.find('a'),
        href = a.attr('href');

    $.log('init tabs', href);
    li.click(function() {
      ul.removeClass('active');
      li.addClass('active');
      tabs.removeClass('active');
      $(tabs[i]).addClass('active');

      window.location.hash = href;
      return false;
    })
  });
}
