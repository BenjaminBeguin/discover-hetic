class PostsController < ApplicationController

    def not_found
        render file: "#{Rails.root}/public/404.html", layout: false, status: 404    
    end

    def show
        @post = Post.find_by_id(params[:id]) or not_found
    end

    def index
        @posts = Post.all
    end

    def unpublish!
        @post_to_update = Post.find_by_id(params[:id]) or not_found
        @post_to_update.published = false
        @post_to_update.save!
        #render :json => @post_to_update 
        #render :nothing => true
        redirect_to action: "index"
    end

    def publish!
        @post_to_update = Post.find_by_id(params[:id]) or not_found
        @post_to_update.published = true
        @post_to_update.save!
        #render :json => @post_to_update 
        #render :nothing => true
        redirect_to action: "index"
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
  end

  def vote
  end
end
