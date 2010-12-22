function() {
  var self = this;

  function login() { 
    self.trigger('loginForm'); 
    return false; 
  }

  function signup() { 
    self.trigger('signupForm'); 
    return false; 
  }

  return {
    "a[href=#login]":  {"click": login},
    "a[href=#signup]": {"click": signup}
  }
}
