var Newpost = function(){ 	 

	// DOM
	this.id = 'newpost';
	this.fileField = $('#newpost_form_file');
	this.fileFieldWrapper =$('.file-input');

	this.init(); 

};

// Init view
Newpost.prototype.init = function() {

	this.bind();

};

// Bind view events
Newpost.prototype.bind = function(){

	var self = this;

	this.fileField.on('mouseenter', function(){
		
		self.fileFieldWrapper.addClass('file-input-hover');
	});

	this.fileField.on('mouseleave', function(){
		
		self.fileFieldWrapper.removeClass('file-input-hover');
	});

};
