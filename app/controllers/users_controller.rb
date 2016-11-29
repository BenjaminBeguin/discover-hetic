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

    def not_found
      render file: "#{Rails.root}/public/404.html", layout: false, status: 404    
    end

    def edit_user_post
        @post = Post.find_by_id(params[:id]) or not_found;
        @categories = Category.all
        if @post 
            if is_my_post?
              redirect_to users_posts_path
            end
        end
    end

    def is_my_post?
        @post.user_id != current_user.id
    end

end
