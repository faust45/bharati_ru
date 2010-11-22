function(doc, resp) {
  return {items: resp.rows, albumRev: doc._rev}
}
