class PostsController < ApplicationController
    def index
        @connected = user_signed_in?
        @posts = Post.paginate(:page => params[:page], :per_page => 6)
        @day = Time.now
        @top_post = top_of_the_day(@day);
    end
    
    def top_of_the_day(date)
        @top_post = Post.where(created_at: date.midnight..date.end_of_day).order(vote: :desc).first
    end

    def show
        @connected = user_signed_in?
        @post = Post.find_by_id(params[:id]) or not_found
        @comments = Comment.where(post_id: params[:id])
    end



    #------------------ filter and order -----------------#
    def category
        @category_slug = params[:slug];
        @category = Category.where(slug: @category_slug).first

        if  !@category.blank?

            if params[:orderby] == 'top'
                @posts = Post.where(category_id: @category.id).order(vote: :desc)
            else
                @posts = Post.where(category_id: @category.id).order(created_at: :desc)
            end

            #--- get the first by vote --#
            @top_post = Post.where(category_id: @category.id).order(vote: :desc).first
        else
            redirect_to action: "index"
        end
    end



    #------------------ SECURE BY USER LOGIN -----------------#

    def unpublish!
        @post_to_update = Post.find_by_id(params[:id]) or not_found
        if @post_to_update.user_id = current_user.id
            @post_to_update.published = false
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

    def vote
        @connected = user_signed_in?
        if @connected
            @post = Post.find(params[:id])
            @already_voted = Vote.where(user_id: current_user.id , post_id: @post.id);
            if @already_voted.empty?
                @post.update(vote: @post.vote + 1)
                @post.save
                @vote = Vote.create(user_id: current_user.id , post_id: @post.id)
                @vote.save

                redirect_to posts_path 
            else
                @post.update(vote: @post.vote - 1)
                @post.save
                Vote.delete(@already_voted.first.id)
                
                redirect_to posts_path 
            end
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
            if @post.save
                @post.validate!   
                redirect_to action: "index"
            else
                @post.validate!   
            end
        end
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
                if @post.save                    
                    render json: @post
                else
                  
                end
            else
                redirect_to new_user_session_path 
            end
        else
            redirect_to new_user_session_path 
        end
    end


  #---------------- Function ------------------#

   def not_found
        redirect_to root_path
       # render file: "#{Rails.root}/public/404.html", layout: false, status: 404    
    end
end
