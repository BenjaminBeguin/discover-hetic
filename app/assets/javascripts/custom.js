$(document).ready(function(){$(".search-button").on("click",function(){var a=$(".search-form");a.hasClass("active")||(event.preventDefault(),a.addClass("active"))}),$("main").on("click",function(){$(".search-form").hasClass("active")&&$(".search-form").removeClass("active")}),$("#user_avatar").on("change",function(a){$val=$(a.target).val(),$val&&$(".upload-avatar-check").show()})});