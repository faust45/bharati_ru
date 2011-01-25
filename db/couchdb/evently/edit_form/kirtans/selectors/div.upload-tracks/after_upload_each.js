function(e, book, resp, fileName, url) {
  //var audio = new Audio();
  //audio.preload= 'metadata';
  //audio.src = url;

  //audio.addEventListener('loadedmetadata', function() {
   // var duration = Math.round(audio.duration) * 1000;
    $.getJSON('http://id3tags.bharati.ru' + url.replace(/^.*\:\d+/, '') + '?callback=?', function(tags) {
      AudioBook(book).add(resp.id, fileName, tags);
    });
 // }, false);
}
