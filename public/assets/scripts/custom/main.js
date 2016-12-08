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

	$('#user_avatar').on('change', function (e) {
		
		$val = $(e.target).val();

		if($val) {
			$('.upload-avatar-check').show();
		}
	});

	new Newpost();


	var makerLink = $('.maker-link');
	var audio = new Audio(BASE_URL+'assets/sound/waf.wav');

	makerLink.on('mouseover', function (e) {
		audio.pause();
		audio.currentTime = 0;
		audio.play();
	});

});