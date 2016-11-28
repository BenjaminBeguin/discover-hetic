class PostsController < ApplicationController
    
  def index
    @posts = Post.all
   
  end

  def category
    @category_slug = params[:slug]
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
