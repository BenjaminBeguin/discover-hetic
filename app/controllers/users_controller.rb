class UsersController < ApplicationController


    #------------------ SECURE BY USER LOGIN -----------------#
    def index
    	@connected = user_signed_in?
    	if !@connected  	
    		redirect_to new_user_session_path
    	end
    	@users = User.all
    end

    def get_user_post
        if user_signed_in?
            @posts = Post.where(user_id: current_user.id);
            post_like_unlike
        else
            redirect_to new_user_session_path 
        end
    end
    
    def edit_user_post
        @connected = user_signed_in?
        if @connected      
            @post = Post.find_by_id(params[:id]) or not_found;
            @categories = Category.all
            if @post 
                if !is_my_post?
                  redirect_to users_posts_path
                end
            end
        else
           redirect_to new_user_session_path 
        end
    end

    def is_my_post?
        @post.user_id == current_user.id
    end

    def not_found
      render file: "#{Rails.root}/public/404.html", layout: false, status: 404    
    end

    def post_like_unlike
        if user_signed_in?
            posts_voted = Vote.select(:post_id).where(user_id: current_user.id)
            @post_voted = [];
            posts_voted.each do |post_voted|
                @post_voted << post_voted.post_id
            end

            @post_voted            
        end
    end
end
