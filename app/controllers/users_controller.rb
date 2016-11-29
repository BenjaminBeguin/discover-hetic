class UsersController < ApplicationController

    def index
    	@connected = user_signed_in?
    	if !@connected  	
    		redirect_to new_user_session_path
    	end
    	@users = User.all
    end

    def get_user_post
        @posts = Post.where(user_id: current_user.id);
    end

    def edit_user_post
        @post = Post.where(id: params[:id]).first;
        if is_my_post?
          redirect_to users_posts_path
        end
    end

    def is_my_post?
        @post.user_id != current_user.id
    end

end
