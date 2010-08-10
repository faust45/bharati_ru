jQuery(function ($) {

  $(document).ready(function() {
    var inputAutocomplete = $('div.autocomplete');

    inputAutocomplete.each(function(i) {
      var idField = $(this).find('input[type=hidden]');
      var idField = $(this).find('input[type=hidden]');
      var autocompleteField = $(this).find('input.autocomplete')
      var url = autocompleteField.attr('data-url');

      var field = autocompleteField.autocomplete(url, {
        width: 320,
        dataType: 'json',
        highlight: false,
        scroll: true,
        scrollHeight: 300,
        matchSubset: false,
      });

      field.result(function(event, item, id, id2) {
        idField.val(item[1]);
      });
    });
  });

});

