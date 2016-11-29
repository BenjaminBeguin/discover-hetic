class PostsController < ApplicationController

    def not_found
        render file: "#{Rails.root}/public/404.html", layout: false, status: 404    
    end

    def show
        @post = Post.find_by_id(params[:id]) or not_found
        @comments = Comment.where(post_id: params[:id])
        @connected = user_signed_in?
    end

    def index
        @posts = Post.all
    end

    def category
        @category_slug = params[:slug];

        if Category.where(slug: @category_slug).first
            @category = Category.where(slug: @category_slug).first;
            @posts = Post.where(category_id: @category.id)
        else
            redirect_to action: "index"
        end
    end

    #------------------ SECURE BY USER LOGIN -----------------#

    def unpublish!
        @post_to_update = Post.find_by_id(params[:id]) or not_found

        if @post_to_update.user_id = current_user.id
            @post_to_update.published = false
            puts @post_to_update.published
            @post_to_update.save!
            #render :json => @post_to_update 
            #render :nothing => true
            redirect_to action: "index"
        else
            redirect_to new_user_session_path 
        end
    end

    def publish!
        @post_to_update = Post.find_by_id(params[:id]) or not_found
        if @post_to_update.user_id = current_user.id
            @post_to_update.published = true
            @post_to_update.save!
            #render :json => @post_to_update 
            #render :nothing => true
            redirect_to action: "index"
        else
            redirect_to new_user_session_path 
        end
    end

    def new
        @connected = user_signed_in?
        if @connected
            @post = Post.new
            @categories = Category.all;
        else
            flash[:error] = 'You need to be login to post'
            redirect_to action: "index"
        end
    end

  def create
    @connected = user_signed_in?
    if @connected
        @post = Post.new(
            title: params[:post][:title],
            user_id: current_user.id,
            category_id: params[:post][:category_id],
            url: params[:post][:url],
            content: params[:post][:content]
        )
        @post.save
    end

    redirect_to action: "index"
  end

  def update
    @connected = user_signed_in?
    if @connected
        @post = Post.find(params[:post][:id])
        if @post.user_id = current_user.id
            @post.update(
                title: params[:post][:title],
                category_id: params[:post][:category_id],
                url: params[:post][:url],
                content: params[:post][:content]
                )
            @post.save!
            render json: @post 
        else
            redirect_to new_user_session_path 
        end
    else
        redirect_to new_user_session_path 
    end
  end

  def vote
  end
end
