class UsersController < ApplicationController


    #------------------ SECURE BY USER LOGIN -----------------#
    def index
        @connected = user_signed_in?
        if !@connected      
            redirect_to new_user_session_path
        end
        @users = User.all
    end

    # @user_votes = Vote.paginate(:page => params[:page], :per_page => POST_PER_PAGE).where(user_id: @user.id).order('created_at DESC')
    # @posts = []
    # @user_votes.each do |vote|
    #     @posts.push(Post.where(user_id: vote.user_id))
    # end
    def get_user_post
        if user_signed_in?
            @user = User.find(current_user.id)

            if params[:mypost] == 'voted'
                @posts = User.find(current_user.id).voted_posts.paginate(:page => params[:page], :per_page => POST_PER_PAGE).order(id: :desc);
            else
                @posts = Post.paginate(:page => params[:page], :per_page => POST_PER_PAGE).where(user_id: current_user.id).order('created_at DESC').order(id: :desc);
            end
            
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
        redirect_to not_found_path      
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
