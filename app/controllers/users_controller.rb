class UsersController < ApplicationController
 
  def index
  	@connected = user_signed_in?
  	if !@connected  	
  		redirect_to new_user_session_path
  	end
  	@users = User.all
  end

end
