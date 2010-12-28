function(e, book, resp, fileName, url) {
  var audio = new Audio();
  audio.preload= 'metadata';
  audio.src = url;

  audio.addEventListener('loadedmetadata', function() {
    var duration = Math.round(audio.duration) * 1000;

    $.getJSON('http://192.168.1.100:8124/' + resp.id + '/' + fileName + '?callback=?', function(tags) {
      tags.duration = duration;
      AudioBook(book).add(resp.id, fileName, tags);
    });
  }, false);
}
