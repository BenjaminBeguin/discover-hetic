$(document).ready(function(){$(".search-button").on("click",function(){var e=$(".search-form");e.hasClass("active")||(event.preventDefault(),e.addClass("active"))}),$("main").on("click",function(){$(".search-form").hasClass("active")&&$(".search-form").removeClass("active")}),$("#user_avatar").on("change",function(e){$val=$(e.target).val(),$val&&$(".upload-avatar-check").show()}),new Newpost;var e=$(".maker-link"),i=new Audio(BASE_URL+"assets/sound/waf.wav");e.on("mouseover",function(e){i.pause(),i.currentTime=0,i.play()})});var Newpost=function(){this.id="newpost",this.fileField=$("#newpost_form_file"),this.fileFieldWrapper=$(".file-input"),this.init()};Newpost.prototype.init=function(){this.bind()},Newpost.prototype.bind=function(){var e=this;this.fileField.on("mouseenter",function(){e.fileFieldWrapper.addClass("file-input-hover")}),this.fileField.on("mouseleave",function(){e.fileFieldWrapper.removeClass("file-input-hover")})};