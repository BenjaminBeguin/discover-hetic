$(document).ready(function(){function e(e){var i=$(e).find("img"),s=i.siblings("span"),t=parseInt(s.text());i.hasClass("active")?(i.removeClass("active"),i.attr("src","/assets/images/icons/like_inactive.svg"),t--,s.text(t)):(i.addClass("active"),i.attr("src","/assets/images/icons/like_active.svg"),t++,s.text(t));var a=new TimelineLite;a.to(i,.2,{scale:1.2,rotation:"+10",ease:Power2.ease}),a.to(i,.2,{scale:1,rotation:"0",ease:Power2.ease})}function i(){if(this.files&&this.files[0]){var e=new FileReader;e.onload=function(e){$(".image-input").css("background-image","url("+e.target.result+")")},e.readAsDataURL(this.files[0])}}$(".search-button").on("click",function(){var e=$(".search-form");e.hasClass("active")||(event.preventDefault(),e.addClass("active"))}),$(".dismiss").on("click",function(){$(".on_submit_feedback").fadeOut(),$(".on_submit_feedback_forms").fadeOut()}),$("main").on("click",function(){$(".search-form").hasClass("active")&&$(".search-form").removeClass("active")}),$("#user_avatar").on("change",i),$("#post_asset").on("change",i),$(".post-likes").on("click",function(){$(".hider").addClass("active"),e(this),setTimeout(function(){$(".hider").removeClass("active")},1e3)}),$(".post-published a").on("click",function(){var e=$(this).find(".publish-switch"),i=e.siblings("span");console.log($(this).attr("link_publish")),e.hasClass("active")?(e.removeClass("active"),i.text("Publish"),console.log($(this)),$(this).attr("href",$(this).attr("link_unpublish"))):(e.addClass("active"),i.text("Unpublish"),$(this).attr("href",$(this).attr("link_publish")))}),new Newpost;var s=$(".maker-link"),t=new Audio(BASE_URL+"assets/sound/waf.wav");s.on("mouseover",function(e){t.pause(),t.currentTime=0,t.play()})});var Newpost=function(){this.id="newpost",this.fileField=$("#newpost_form_file"),this.fileFieldWrapper=$(".file-input"),this.init()};Newpost.prototype.init=function(){this.bind()},Newpost.prototype.bind=function(){var e=this;this.fileField.on("mouseenter",function(){e.fileFieldWrapper.addClass("file-input-hover")}),this.fileField.on("mouseleave",function(){e.fileFieldWrapper.removeClass("file-input-hover")})};