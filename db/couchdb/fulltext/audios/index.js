function(doc) {
  if(doc['couchrest-type'] == 'Audio') {
     var ret = new Document();
     ret.add(doc.title, {"store": "yes", "boost": 10.0});

     for(var i in doc.tags) {
       ret.add(doc.tags[i], {"store": "yes", "boost": 7.0});
     }

     if (doc.bookmarks) {
       for(var i in doc.bookmarks) {
         var mark = doc.bookmarks[i]
         ret.add(mark.name, {"boost": 5.0});
       }
     }

     ret.add(doc.description, {});

     return ret;
   }
}
