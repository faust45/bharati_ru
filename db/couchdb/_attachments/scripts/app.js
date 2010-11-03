MyApp = {
  init: function() {
  }
}

EditDocForm = {
  currentDoc: null,

  docId: function() {
    return this.currentDoc._id;
  },

  doc: function() {
    return this.currentDoc;
  }

}

ImgUpdater = function(doc, attr) {
  function updateOwner(resp) {
    $.log('update owner');

    if(isBlank(doc[attr])) {
      doc[attr] = [resp.id];
      DocsStore.saveDoc(doc, function() {
        $.log(doc[attr]);
      });
    }
    //DocsStore.saveDoc(doc);
  }

  return {
    url: function(fileName) {
      var id = isBlank(doc.cover_attachments) ? $.couch.newUUID() : doc.cover_attachments[0];
      return FileStore.uri + id + '/' + changeFileName(fileName, 'img');
    },

    uploadComplete: function(resp) {
      updateOwner(resp);
    }
  }
}

DocsStore = $.couch.db('rocks_dev');
FileStore = $.couch.db('rocks_file_store_dev');

$(document).ready(function() {
  //$.ajaxSetup({transport:'flXHRproxy'});
  //$.flXHRproxy.registerOptions("http://127.0.0.1/",{xmlResponseText:false});

  //$.post( 'http://127.0.0.1/upload', {});
});
