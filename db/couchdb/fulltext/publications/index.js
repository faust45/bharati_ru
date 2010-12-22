function(doc) {
  if(doc['couchrest-type'] == 'Publication') {
     var ret = new Document();

     ret.add(doc.title, {});

     return ret;
  }
}
