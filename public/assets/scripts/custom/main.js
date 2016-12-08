$(document).ready(function(){

	//EXPAND SEARCH
	$('.search-button').on('click', function(){		
		var form = $('.search-form');

		if(!form.hasClass('active')){
			event.preventDefault();
			
			form.addClass('active');
		}
	});

	$('.dismiss').on('click', function(){		
		$('.on_submit_feedback').fadeOut();
		$('.on_submit_feedback_forms').fadeOut();
	});

	$('main').on('click', function(){
		if($('.search-form').hasClass('active')){
			$('.search-form').removeClass('active');
		}
	})

	$('#user_avatar').on('change', previewImageUploaded);
	$('#post_asset').on('change', previewImageUploaded);


	//Likes toggle
	function like_post(link){

		var img = $(link).find('img');
		var number = img.siblings('span');
		var value = parseInt(number.text());
		if(img.hasClass('active')){
			img.removeClass('active');
			img.attr("src", '/assets/images/icons/like_inactive.svg');
			value--;
			number.text(value);
		}
		else{
			img.addClass('active');
			img.attr("src", '/assets/images/icons/like_active.svg');
			value++;
			number.text(value);
		}	
	}

	$('.post-likes').on('click', function(){
		$('.hider').addClass('active');
		like_post(this);
		setTimeout(function(){
			$('.hider').removeClass('active');
		}, 1000);
	});

	//Publish toggle
	$('.post-published a').on('click', function(){

		var button = $(this).find('.publish-switch');
		var span = button.siblings('span');

		console.log($(this).attr('link_publish'));

		if(button.hasClass('active')){
			button.removeClass('active');
			span.text('Publish');
			
			console.log($(this));

			$(this).attr('href', $(this).attr('link_unpublish'));
		}
		else{
			button.addClass('active');
			span.text('Unpublish');

			$(this).attr('href', $(this).attr('link_publish'));
		}
	});

	function previewImageUploaded () {
		
		if(this.files && this.files[0]) {
			var reader = new FileReader();

			reader.onload = function(e) {
				$('.image-input').css('background-image', 'url('+e.target.result+')')
			}
			reader.readAsDataURL(this.files[0]);
		}
	}

	new Newpost();

	var makerLink = $('.maker-link');
	var audio = new Audio(BASE_URL+'assets/sound/waf.wav');

	makerLink.on('mouseover', function (e) {
		audio.pause();
		audio.currentTime = 0;
		audio.play();
	});

});