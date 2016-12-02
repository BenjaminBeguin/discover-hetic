$(document).ready(function(){

	$('.search-button').on('click', function(){		
		var form = $('.search-form');

		if(!form.hasClass('active')){
			event.preventDefault();
			
			form.addClass('active');
		}
	});

	$('main').on('click', function(){
		if($('.search-form').hasClass('active')){
			$('.search-form').removeClass('active');
		}
	})

});