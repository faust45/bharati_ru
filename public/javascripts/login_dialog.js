//--------------------------------------------------------------

Login = {};

//--------------------------------------------------------------
//Initialization


$(document).ready(function() {
  $('#pop a.close').click(function() {
    $('#pop').dialog('close');
    return false;
  });

  RegDialog($('#regist'));
  LoginDialog($('#login-form'));
});

//--------------------------------------------------------------

DialogBase = function(form, onResponce, errors) {
  form.bind('ajax:success', onResponce)
  form.find('.errors').append(errors);

  form.find('a.butt').click(function() {
    form.submit();
    return false;
  });
}

LoginDialog = function(form) {
  var errors = $('<p></p>');
  DialogBase.apply(this, [form, onResponce, errors]);

  function onResponce(e, data) {
    var data = eval('(' + data + ')');

    if (data.login_success) { 
      window.location.reload()
    } else {
      errors.html('');
      $(data.errors).each(function() {
        errors.append('<li>' + this.toString() + '</li>')
      });
    }
  }
}


RegDialog = function(form) {
  var errors = $('<ul></ul>');

  DialogBase.apply(this, [form, onResponce, errors]);  

  function onResponce(e, data) {
    var data = eval('(' + data + ')');
    var userCreated = !data.is_new;

    if (userCreated) { 
      //onAuthSuccess();
      var s = Welcome.replace('{{login}}', data.login);
      form.replaceWith(s);
    } else {
      errors.html('');
      $(data.errors).each(function() {
        errors.append('<li>' + this.toString() + '</li>')
      });
    }
  }

  function onAuthSuccess() {
    window.location.reload()
  }
}

Welcome = 'Вы успешно зарегистрировались!  Спасибо, {{login}}.  Войдите, используя имя и пароль, которые вы ввели при регистрации, и вы сможете воспользоваться всеми возможностями форума.'
