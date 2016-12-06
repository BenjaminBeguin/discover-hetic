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

<<<<<<< Updated upstream
	$('#user_avatar').on('change', function (e) {
		
		$val = $(e.target).val();

		if($val) {
			$('.upload-avatar-check').show();
		}
	});
=======
	// Activate newpost's JS 
	new Newpost();
>>>>>>> Stashed changes

});