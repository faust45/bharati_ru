$(document).ready(function(){

	var font = $("#nav ul").width();
	if ( font > 800 ) {
		$("body").addClass("arial");
	};

	//Вынос элементов оформления меню из HTML
	$("#nav li a, #footer li a").css("padding", "0 8px 0 8px").wrapInner("<span></span>").prepend("<b></b>").append("<i></i>");

	//Табы
	$(".tabs").each(function(){
		var cLength = $(this).find('li').length;
		var ii = 0;
		$(this).find("li a").each(function(){
			$(this).attr('rel',ii++);
		});
		delete ii;
		$(this).find('ul').addClass('tab'+cLength);
		$(this).find("li a").click( function(e){
			$(this).parent().parent().find("li a").removeClass("active");
			$(this).addClass("active");
			e.preventDefault();
			var cEl = $(this).parent().parent().parent().parent();
			$(cEl).find(".tab-container").removeClass("active");
			$(cEl).find(".tab-container").eq(
				$(this).attr('rel')
				).addClass('active');
			delete cEl;
		});
		delete cLength;
                if (!$(this).hasClass('login-dialog')) {
		  $(this).find("li").after("<li class='clear'><span><span></li>");
                }
	});

	//Теги
	$(".tags .type a").each(function(){
		if ($(this).height() > 20){
			$(this).addClass("hTwo");
		}
	});


	$("#nav form").hover(function(){
		$(this).addClass("hover");
	}, function (){
		$(this).removeClass("hover");
	});

	$(".searchType a").click(function(){
		$(".searchType a").removeClass("active");
		$(this).addClass("active");
	});

	//Изменение цвета символов в поисковой строке
	$("#nav form .field").focus(function () {
		$(this).addClass("over");
	}).blur(function () {
		$(this).removeClass("over");
	});

});

