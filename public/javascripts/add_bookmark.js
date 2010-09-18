//--------------------------------------------------------------
// Namespace

AddBookmark = {};


//--------------------------------------------------------------
//Interface for server side control.


AddBookmark.Event = {}

AddBookmark.Event.CreateSuccess = function(html) {
  new AddBookmark.MyBookmark(html);
};

AddBookmark.Event.MakeSharedSuccess = function(bm_id, html) {
  var bm = $(html);
  bm.behavior(MyBookmarkBehavior);

  $('#' + bm_id).replaceWith(bm);
  bm.effect("highlight", {color: '#4FE319'}, 6000); 
};

AddBookmark.Event.MakePrivteSuccess = function(bm_id, html) {
  var bm = $(html);
  bm.behavior(MyBookmarkBehavior);

  $('#' + bm_id).replaceWith(bm);
  bm.effect("highlight", {color: '#4FE319'}, 6000); 
};

AddBookmark.Event.CreateFail = function(reason) {
};

AddBookmark.Event.MakeCopySuccess = function(html) {
  new AddBookmark.MyBookmark(html);
};

//--------------------------------------------------------------


function BookmarkBehavior(element, config) {
  var element = $(element);

  var link = element.find('.info a');
  var time = link.attr('data-time');

  link.click(function() {
      Player.gotoTime(time);
      return false;
  });

  element.mouseover(function() {
    element.addClass('bm-active');
  });

  element.mouseout(function() {
    element.removeClass('bm-active');
  });
}

function MyBookmarkBehavior(element, config) {
  element = $(element);

  var link          = element.find('.info a');
  var shareButton   = element.find('a.share');
  var privateButton = element.find('a.private');
  var delButton     = element.find('a.del');
  var time = link.attr('data-time');


  link.click(function() {
      Player.gotoTime(time);
      return false;
  });

  shareButton.click(function() {
    var url = $(this).attr('href');
    $.get(url, function(resp) {
      element.effect("highlight", {}, 6000); 
    });

    return false;
  });

  privateButton.click(function() {
    var url = $(this).attr('href');
    $.get(url, function(resp) {
    });

    return false;
  });

  delButton.click(function() {
    var url = $(this).attr('href');

    $.get(url, function(resp) {
      element.fadeOut('slow');
    });

    return false;
  });

  element.mouseover(function() {
    element.addClass('bm-active');
  });

  element.mouseout(function() {
    element.removeClass('bm-active');
  });
}

//--------------------------------------------------------------
//Initialization


$(document).ready(function() {
  var form = new AddBookmark.Form();

  new AddBookmark.CreateNew(form);
  new AddBookmark.Shared();

  AddBookmark.MyBookmark.each(function() {
    $(this).behavior(MyBookmarkBehavior);
  });

  AddBookmark.Shared.each(function(fun) {
    $(this).behavior(BookmarkBehavior);
  });

  AddBookmark.author().behavior(BookmarkBehavior);
});

//--------------------------------------------------------------

AddBookmark.author = function() {
  return $('.author_bookmarks > .bm');
}

AddBookmark.MyBookmark = function(html) {
  //bookmark (bm)
  var bm = $(html);
  bm.behavior(MyBookmarkBehavior);
  var data = bm.find('a');
  var time = data.attr('data-time');

  $('.my_bookmarks').append(bm);

  bm.effect("highlight", {}, 6000); 
  Player.addNewUserBookmark(time);
}

AddBookmark.MyBookmark.each = function(fun) {
  $('.my_bookmarks > .bm').each(fun);
}

//--------------------------------------------------------------


AddBookmark.CreateNew = function(form) {
  AddBookmark.CreateNew.Dialog = new AddBookmark.Dialog(form);
}

//--------------------------------------------------------------


AddBookmark.Dialog = function(form) {
  var self  = this;
  this.div  = $('#add_bookmark_dialog');
  this.form = form;

  this.div.dialog({
    autoOpen:  false,
    resizable: false,

    buttons: {
      'Cancel': function() { self.close(); },
      'Add':    function() { self.submit(); },
    },

    open:  function() { self.form.titleFocus(); self.form.titleBlank(); },
    close: function() {}
  });
}

AddBookmark.Dialog.prototype = {
  open: function(time) {
    this.form.setTime(time);
    this.div.dialog('open');
  },

  close: function() {
    this.div.dialog('close');
  },

  submit: function() {
    var self = this;

    this.form.submit(function() {
      self.close();
    });
  }
}

//--------------------------------------------------------------


AddBookmark.Form = function() {
  this.form = $('#add_bookmark_form');
  this.form.ajaxForm();
}

AddBookmark.Form.prototype = {
  submit: function(fun, originalID, time, title) {
    if (originalID) {
      this.setOriginalID(originalID);
    }

    if (time) {
      this.setTime(time);
    }

    if (title) {
      this.setTitle(title);
    }


    this.form.ajaxSubmit(fun);
  },

  setTitle: function(value) {
    this.form.find('input[name=bookmark[title]]').val(value);
  },

  setTime: function(value) {
    this.form.find('input[name=bookmark[time]]').val(value);
  },

  titleFocus: function() {
    this.form.find('input[name=bookmark[title]]').focus();
  },

  titleBlank: function() {
    this.setTitle('');
  },


  setOriginalID: function(value) {
    this.form.find('input[name=bookmark[original_id]]').val(value);
  }
}

//----------------------------------------------------------


AddBookmark.Shared = function() {
  AddBookmark.Shared.each(function() {
    var addButton = $(this).find('a.add');

    addButton.click(function() {
      var url = $(this).attr('href');
      $.get(url, function(resp) {
        //eval(resp);
        //new AddBookmark.MyBookmark(eval(resp));
      }); 

      return false;
    });
  });
}

AddBookmark.Shared.each = function(fun) {
  $('.shared_bookmarks > .bm').each(fun);
}
