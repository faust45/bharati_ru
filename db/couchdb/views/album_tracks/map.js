function(doc) {
  if(doc['couchrest-type'] == 'Album') {
    if(doc.tracks) {
       for(var i in doc.tracks) {
         emit([doc._id, parseInt(i)], {_id: doc.tracks[i]});
       };
     }
  }
}
