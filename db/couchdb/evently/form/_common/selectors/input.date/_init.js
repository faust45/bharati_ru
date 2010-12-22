function() {
  var self = $(this);

  $(this).datepicker({
    showOn: 'button',
    buttonImage: 'images/calendar.png',
    buttonImageOnly: true,
    onSelect: function() {
      self.trigger('formChanged');
    }
  });
}
