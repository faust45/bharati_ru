(function ($) {
  $(document).ready(function() {
    var template = $('#template-quote').html();
    var arr = [];

    var formNewPost = $('#create-post');
    formNewPost.find('a[href="#create"]').click(function() {
      formNewPost.submit();
    });

    $('.quote').each(function() {
      arr.unshift($(this));
    });

    $.each(arr, function() {
      var v = $(this).html();
      var author = $(this).attr('data-author');
      $(this).replaceWith($.replaceWith(template, {author: author, quote: v}));
    });

    
    $('a.submit').each(function() {
        $(this).click(function() {
          if($(this).attr('data-target')) {
            var s = '#' + $(this).attr('data-target');
            var form = $('#' + $(this).attr('data-target'));
            form.submit();
          } else {
            console.log($(this).parents().find('form')[0]); //.submit();
          }
          return false;
        })
    });

    $('#button-post-comment').click(function() {
      $('#form-post-comment').submit();
      return false;
    });

    $('.butts a.ans').click(function() {
      var wasHide = $('#ans-area').hasClass('hide');

      if (wasHide) { 
        $('#ans-title').removeClass('hide');
        $('#ans-area').removeClass('hide');
      }

      var rawBody = $(this).parents().find('.raw-body'),
          author = rawBody.attr('data-author');
      var ansTitle = $(this).parents().find('#ans-title');
        var s = $.replaceWith(ansTitle.html(), {responde_to_author: author});
        ansTitle.html(s);
    });

    $('.butts a.ans_with_quote').click(function() {
      var wasHide = $('#ans-area').hasClass('hide');

      if (wasHide) { 
        $('#ans-title').removeClass('hide');
        $('#ans-area').removeClass('hide');

        var rawBody = $(this).parents().find('.raw-body'),
            author = rawBody.attr('data-author'),
            b = "\n\n\n\n[quote author='{{author}}']{{body}}[/quote]";

        var str = $.replaceWith(b, {author: author, body: rawBody.html()});

        var ansTitle = $(this).parents().find('#ans-title');
        var s = $.replaceWith(ansTitle.html(), {responde_to_author: author});
        ansTitle.html(s);
        $('#ans-area textarea').val(str);
      }
    });

    $('a[data-auth=true]').each(function() {
      $(this).click(function() {
        showLoginPopup();
        return false;
      });
    });
  });


  function showLoginPopup() {
    $('#pop').show();
  }
})(jQuery);
