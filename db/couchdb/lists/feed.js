function(head, req) {
  var ddoc = this;
  var Mustache = require("vendor/couchapp/lib/mustache");
  var List = require("vendor/couchapp/lib/list");
  var path = require("vendor/couchapp/lib/path").init(req);
  var Atom = require("vendor/couchapp/lib/atom");
  var markdown = require("vendor/couchapp/lib/markdown");
  //var textile = require("vendor/textile/textile");
  
  //var indexPath = path.list('index', 'audios_all',{descending:true, limit:10});
  //var feedPath = path.list('index','audios_all',{descending:true, limit:10, format:"atom"});
  
  provides("atom", function() {
    // we load the first row to find the most recent change date
    var row = getRow();
    
    // generate the feed header
    var feedHeader = Atom.header({
      updated : (row ? new Date(row.doc.created_at) : new Date()),
      title : 'BharatiRU Audios',
    });
    
    // send the header to the client
    send(feedHeader);

    // loop over all rows
    if (row) {
      do {
        var doc = row.doc, source = doc.source_attachments, fileUrl, photo = doc.photos_attachments, photoId;
        if (photo) {
          photoId = photo[0] && photo[0].doc_id;
        }

        if (source) { 
          var file = source[0];
          fileUrl = 'http://93.94.152.87/rocks_file_store/' + file.doc_id + '/' + file.file_name;
        }
        // generate the entry for this row
        var feedEntry = Atom.entry({
          entry_id : 'http://bharati.ru/audios/show/'+encodeURIComponent(row.id),
          title : doc.title,
          content:  Mustache.to_html(ddoc.templates.mp3player, {fileUrl: fileUrl, photoId: photoId}),
          updated : new Date(doc.created_at),
          author : doc.author_name,
          alternate : 'http://bharati.ru/audios/show/'+encodeURIComponent(row.id)
        });
        // send the entry to client
        send(feedEntry);
      } while (row = getRow());
    }

    var link = Atom.link('next', 'http://bharati.ru/audios/rss?from=10&to=30');
    send(link);
    link = Atom.link('self', 'http://bharati.ru/audios/rss?from=10&to=30');
    send(link);

    // close the loop after all rows are rendered
    return "</feed>";
  });
}
