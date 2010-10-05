$(document).ready(function() {
  //View.TrackForm.setSaveButton($('#edit_menu img'));
  var html = View.AuthorForm.html();
  $('#author-form').append(html);

  $(document).bind('currentAuthorChanged', function(e, id) {
    View.AuthorForm.editDoc(id);
  });

  View.AuthorForm.setSaveButton($('#button-save-author'));
});


View.AuthorForm = {
  paramsSpace: 'author',
  saveURL: '/admin/authors/save',
  fields: {},

  buildForm: function() {
    this.cont = $('<form>');
    var fields = this.fields;

    fields.display_name = StringInput.create();
    fields.mainPhoto = PhotoInput.create('/admin/authors/upload/photo');

    var fieldSet = new FieldSet(fields, ['display_name', 'mainPhoto'], {tab: false});

    this.append([fieldSet]);
    this.listenChanges();

    return this.cont;
  },

  editDoc: function(authorID) {
    var self = this;
    Model.Author.get(authorID, function(doc) {
      self.doc = doc;
      self.refresh();
    });
  }
};

$.extend(View.AuthorForm, FormBase);
