function(e, ev, doc) {
  var counter = 0;
  var book = e.data.args[1];
  App.app.db.allDocs({
      include_docs: true,
      keys: book.tracks,
      success: onLoad 
  });

  function onLoad(resp) {
    setDuration();

    function setDuration() {
      $.log(resp.rows.length);
      var doc = resp.rows.pop().doc;
      $.log(doc.source.file_name);

      if (!doc.duration) {
        var audio = new Audio();
        audio.preload= 'metadata';
        audio.src = 'http://mp3.bharati.ru/rocks_file_store/' + doc.source.doc_id + '/' + doc.source.file_name;

        audio.addEventListener('loadedmetadata', function() {
          doc.duration = Math.round(audio.duration) * 1000;
          $.log(doc.duration);

          DocsStore.saveDoc(doc, {
            success: function() {
                       if (resp.rows.length != 0) {
                         alert('Ok. ' + doc.duration + ' ' + doc.source.file_name);
                         setDuration();
                       } else {
                         alert('Ok. assign duration is complete...');
                       }
                     }
          });

          delete audio;
        }, false);
      }
    }
  }

  return false;
}
