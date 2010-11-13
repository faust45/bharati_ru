function(cb, ev, li) {
  if (li._rev) {
    var doc = li;
    EditDocForm.setDoc(doc); 
    cb(doc);
  } else {
    var id = li.id;
    EditDocForm.openDoc(id, cb);
  }
}

