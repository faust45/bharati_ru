jQuery(function ($) {

  $(document).ready(function() {
    var inputMarksDivs = $('div.marks_autocomplete, div.tags_autocomplete');

    inputMarksDivs.each(function(i) {
      new MarkControl(this);
    });
  });
});

//----------------------------------------------------------------------------------------


  MarkControl = function(div) {
    var self = this;

    this.controlContainer  = $(div);
    this.marksContainer    = this.controlContainer.children('div.marks:first');
    this.autocompleteField = this.controlContainer.children('input.autocomplete:first');
    this.addButton         = this.controlContainer.children('img.add_button:first');

    var params = this.marksContainer.children('input[data-marks]:first');
    this.acceptParamsName = params.attr('name');
    this.autoCompleteUrl  = params.attr('data-url');
    var marks             = params.attr('data-marks');

    marks = eval('(' + marks + ')');
    $.each(marks, function(id, label) {
      new Mark(id, label, self);
    });

    this.bindAutocompleter();
    //Working only for tags
    this.bindAddButton();

  };

  MarkControl.prototype = {
    bindAutocompleter: function() {
      var self = this;

      $(this.autocompleteField).autocomplete(this.autoCompleteUrl, {
        width: 320,
        dataType: 'json',
        highlight: false,
        scroll: true,
        scrollHeight: 300,
        matchSubset: false,
      }).result(function(event, item) {
        new Mark(item[1], item[0], self);
      });
   },

   bindAddButton: function() {
    var self = this;

    if(this.addButton) {
      this.addButton.bind('click', function() {
        var value = self.autocompleteField.val();
        new Mark(value, value, self);
      });
    }
   },

   findMark: function(id) {
     var path ='input[value='+ id +']:first';
     var checkbox = this.marksContainer.find(path);

     return checkbox.parent('label:first'); 
   },

   addMark: function(mark) {
     this.marksContainer.append(mark);
   }

  };

//--------------------------------//

  Mark = function(id, labelText, container) {
    this.container = container;
    this.id = id || labelText;
    this.labelText = labelText;

    !this.isExists() ?  this.create() :
                        this.highlight();
  };

  Mark.prototype = {
    id: null,
    labelText: null,

    create: function() {
      var label = $('<label>');
      var checkbox = $('<input>', {type: 'checkbox', checked: true, name: this.container.acceptParamsName, value: this.id});

      label.append(checkbox);
      label.append(this.labelText);
      label.click(function() {
        label.remove();
      });

      this.container.addMark(label);
      return label;
    },

    isExists: function() {
      var mark = this.container.findMark(this.id);
      return mark.size() > 0; 
    },

    highlight: function() {
      var mark = this.container.findMark(this.id);
      mark.effect("highlight", {}, 3000);
    }
  };
