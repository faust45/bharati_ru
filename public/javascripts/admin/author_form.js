$(document).ready(function() {
  //View.TrackForm.setSaveButton($('#edit_menu img'));
  var html = View.AuthorForm.html();
  $('#author-form').append(html);

  $(document).bind('currentAuthorChanged', function(e, id) {
    View.AuthorForm.editDoc(id);
  });

  $(document).bind('keydown', 'n', function() {
    View.AuthorForm.addNew();
  });


  View.AuthorForm.setSaveButton($('#button-save-author'));
});


View.AuthorForm = {
  paramsSpace: 'author',
  saveURL: '/admin/authors/save',
  newURL: '/admin/authors/new',
  fields: {},

  buildForm: function() {
    this.cont = $('<form>');
    var fields = this.fields;

    fields.display_name = StringInput.create();
    fields.mainPhoto = PhotoInput.create('/admin/authors/upload/photo', {class: 'author-main-photo'});

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
  },

  addNew: function() {
    this.doc = {};
    this.refresh();
  }
};

$.extend(View.AuthorForm, FormBase);
