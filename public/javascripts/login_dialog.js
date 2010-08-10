//--------------------------------------------------------------

Login = {};

//--------------------------------------------------------------
//Initialization


$(document).ready(function() {
  var dialog = new Login.Dialog();
  $('a.login').click(function() {
    dialog.open();
    return false;
  });
});

//--------------------------------------------------------------


Login.Dialog = function() {
  var self  = this;
  this.div  = $('#login_dialog');
  this.form = new Login.Form(this.div.find('form'), this.process());
  this.msg  = this.div.find('.msg');

  this.div.dialog({
    autoOpen:  false,
    resizable: false,
    minWidth:  '300px',
    modal: true,

    buttons: {
      'Cancel': function() { self.close();  },
      'Enter':  function() { self.submit(); },
    },

    open:  function() { self.form.loginFocus(); self.form.setLogin(''); },
    close: function() {}
  });
}

Login.Dialog.prototype = {
  open: function() {
    this.div.dialog('open');
    this.msg.html('');
  },

  close: function() {
    this.div.dialog('close');
  },

  submit: function() {
    this.form.submit(this.process());
  },

  process: function() {
    var self = this;

    return function(resp) {
      var r = eval( "(" + resp + ")" );
      if (r.login_success) {
        self.close();
        location.reload();
      } else {
       self.msg.html(r.flash);
       self.msg.effect("highlight", {}, 6000); 
      }
    }
  }
}

//--------------------------------------------------------------


Login.Form = function(form, fun) {
  this.form = form;
  this.form.ajaxForm(fun);
}

Login.Form.prototype = {
  submit: function(fun) {
    this.form.ajaxSubmit(fun);
  },

  setLogin: function(value) {
    this.form.find('input[name=user[login]]').val(value);
  },

  setPassword: function(value) {
    this.form.find('input[name=user[password]]').val(value);
  },

  loginFocus: function() {
    this.form.find('input[name=user[login]]').focus();
  }
}
