MyApp = {
  init: function() {
  }
}

$.fn.formTabs = function() {
  var tabs = $('form').find('div.cnt');
  var ul = $(this).find('li');

  ul.each(function(i) {
    var li = $(this);
    var a = li.find('a');

    li.click(function() {
      ul.removeClass('active');
      li.addClass('active');
      tabs.removeClass('active');
      $(tabs[i]).addClass('active');

      return false;
    })
  });
}

$.fn.tabs = function() {
  var tabs = $('form').find('div.cnt');
  var ul = $(this).find('li');

  ul.each(function(i) {
    var li = $(this);
    var a = li.find('a'),
        href = a.attr('href');

    $.log('init tabs', href);
    li.click(function() {
      ul.removeClass('active');
      li.addClass('active');
      tabs.removeClass('active');
      $(tabs[i]).addClass('active');

      window.location.hash = href;
      return false;
    })
  });
}
