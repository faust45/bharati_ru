function(doc) {
  if(doc['couchrest-type'] == 'Album') {
    if(doc.tracks) {
       var sortBy = doc.is_hand_sort ? i : doc.record_date;

       for(i in doc.tracks) {
         emit([doc._id, sortBy], {_id: doc.tracks[i]});
       };
     }
  }
}
