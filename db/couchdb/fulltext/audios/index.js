function(doc) {
  if(doc['couchrest-type'] == 'Audio') {
     var ret = new Document();
     ret.add(doc._id, {});
     ret.add(doc.title, {field: "title", "boost": 10.0});

     if(doc.tags) {
       ret.add(doc.tags.join(','), {field: "tags", "boost": 7.0});
     }

     if (doc.bookmarks) {
       var cont = [];
       for(var i in doc.bookmarks) {
         cont.push(doc.bookmarks[i].name)
       }
       
       ret.add(cont.join(','), {field: "bookmarks", "boost": 5.0});
     }

     if (doc.description) {
       ret.add(doc.description, {});
     }

     if (doc.author_id) {
       ret.add(doc.author_id, {field: "author_id"});
     }

     if (doc.record_date) {
       var date = doc.record_date;
       year = date.slice(0, 4);
       ret.add(year, {field: "year"});
     }


     return ret;
   }
}
