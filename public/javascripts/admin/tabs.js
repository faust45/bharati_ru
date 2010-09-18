//--------------------------------------------------------------
//Initialization

$(document).ready(function() {
  $('.tabs_control').behavior(TabsBehavior);
});


//--------------------------------------------------------------
function TabsBehavior(element, config) {
  var element = $(element);

  var ref  = element.attr('data-tabsId');
  var tabs = element.find('li');
  var tabsCont = $('#' + ref + ' .tab');

  new Tab(tabs, tabsCont);
}


//--------------------------------------------------------------
Tab = function(tabs, tabsCont) {
  var self = this;

  tabs.each(function(i) {
    var cont = tabsCont[i];

    $(this).click(function() {
      self.switchTo(this, cont);
      return false;
    });

    if ($(this).hasClass('active')) {
      self.switchTo(this, cont);
    }
  });
};

Tab.prototype = {
  currentTab: null,
  currentCont: null,

  switchTo: function(clickTab, cont) {
    var clickTab = $(clickTab);
    var cont = $(cont);

    if (this.currentTab) {
      this.currentTab.removeClass('active');
      this.currentCont.removeClass('active');
    }

    clickTab.addClass('active');
    cont.addClass('active');

    this.currentTab  = clickTab;
    this.currentCont = cont;
  }
};
