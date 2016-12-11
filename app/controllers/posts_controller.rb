class PostsController < ApplicationController
    def index
        #Post.update_all(published: false)

        if params[:orderby] == 'top'
            @posts = Post.paginate(:page => params[:page], :per_page => POST_PER_PAGE).order('vote DESC').published
        else
            @posts = Post.paginate(:page => params[:page], :per_page => POST_PER_PAGE).order('id DESC').published
        end

        @post_voted = post_like_unlike
        @day = Date.yesterday
        @top_post = top_of_the_day(@day);
        @best_users = get_best_users
    end
    
    def top_of_the_day(date)
        Post.where(created_at: date.midnight..date.end_of_day).order(vote_created: :desc).published.first
    end

    def get_best_users
        @all_user = User.order(vote_count: :desc).limit(5)
    end

    def show
        @post = Post.find_by_id(params[:id]) or not_found
        @comments = Comment.where(post_id: params[:id]).order(id: :desc)
        post_like_unlike
    end

    def search
        if params[:q]
            if params[:orderby] == 'top'
                @posts = Post.search(params[:q]).paginate(:page => params[:page], :per_page => POST_PER_PAGE).order('vote DESC').published
            else
                @posts = Post.search(params[:q]).paginate(:page => params[:page], :per_page => POST_PER_PAGE).order('created_at DESC').published
            end
        else
            if params[:orderby] == 'top'
                @posts = Post.paginate(:page => params[:page], :per_page => POST_PER_PAGE).order('vote DESC').published
            else
                @posts = Post.paginate(:page => params[:page], :per_page => POST_PER_PAGE).order('created_at DESC').published
            end
        end
        @post_voted = post_like_unlike
    end

    #------------------ filter and order -----------------#
    def category
        @category_slug = params[:slug];
        @category = Category.where(slug: @category_slug).first

        if  @category.present?
            if params[:orderby] == 'top'
                @posts = Post.paginate(:page => params[:page], :per_page => POST_PER_PAGE).where(category_id: @category.id).order(vote: :desc).published
            else
                @posts = Post.paginate(:page => params[:page], :per_page => POST_PER_PAGE).where(category_id: @category.id).order(created_at: :desc).published
            end

            post_like_unlike

            #--- get the first by vote --#
            date = Date.yesterday
            @top_post = Post.where(category_id: @category.id, created_at: date.midnight..date.end_of_day).order(vote: :desc).published.first
        else
            not_found
        end
    end

    def post_like_unlike
        if user_signed_in?
            posts_voted = Vote.select(:post_id).where(user_id: current_user.id)
            @post_voted = [];
            posts_voted.each do |post_voted|
                @post_voted << post_voted.post_id
            end
            @post_voted            
        else
            @post_voted = [];
        end
    end

    def by_user
        @user_slug = params[:slug];
        @user = User.where(slug: @user_slug).first

        if  @user.present?
            if params[:orderby] == 'top'
                @posts = Post.paginate(:page => params[:page], :per_page => POST_PER_PAGE).where(user_id: @user.id).order('vote DESC').order(created_at: :desc).published
            else
                @posts = Post.paginate(:page => params[:page], :per_page => POST_PER_PAGE).where(user_id: @user.id).order('created_at DESC').order(created_at: :desc).published
            end
            post_like_unlike
        else
            
        end
    end

    #------------------ SECURE BY USER LOGIN -----------------#

    def unpublish!
        @post_to_update = Post.find_by_id(params[:id]) or not_found
        if @post_to_update.user_id = current_user.id
            @post_to_update.published = false
            @post_to_update.save!
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
            redirect_to action: "index"
        else
            redirect_to new_user_session_path 
        end
    end

    def vote
        if user_signed_in?
            @post = Post.find(params[:id])
            already_voted = Vote.where(user_id: current_user.id , post_id: @post.id).first;
            if !already_voted
                @post.increment
                if @post.created_today?
                    @post.update(vote_created: @post.vote_created + 1)
                end
                @vote = Vote.create(user_id: current_user.id , post_id: @post.id)
            else
                @post.decrement
                if @post.created_today?
                    @post.update(vote_created: @post.vote_created - 1)
                end
                already_voted.destroy
            end
            redirect_to posts_path
        else
            flash[:error] = 'You need to be signed in to vote'
            redirect_to new_user_session_path 
        end
    end

    def new
        @connected = user_signed_in?
        date = Time.now;
        if @connected
            @has_voted = Post.where(created_at: date.midnight..date.end_of_day, user_id: current_user.id).first
            if @has_voted.blank?
                @post = Post.new
                @categories = Category.all;
            else
                # @message = "You have already posted today ! "
                @message = ""
                flash[:error] = 'You have already posted today !'
                redirect_to root_path 
             end
        else
            flash[:error] = 'You have to be logged in to create a post'
            redirect_to new_user_session_path 
        end
    end

    def create
        date = Time.now;
        if user_signed_in?
            @has_voted = Post.where(created_at: date.midnight..date.end_of_day, user_id: current_user.id).first
            if @has_voted.blank?
                @post = Post.new(params.require(:post).permit(:title, :category_id, :url, :content, :asset));
                @post.user_id = current_user.id 
                if @post.save 
                    redirect_to action: "index"
                else
                    @categories = Category.all;
                    render :new  
                end
            else
                flash[:error] = 'You have already posted today !'
                redirect_to root_path  
            end
        end
    end

    def update
        @connected = user_signed_in?
        if @connected
            @post = Post.find(params[:post][:id])
            if @post.user_id = current_user.id
                @post.update(params.require(:post).permit(:title, :category_id, :url, :content , :asset));
                if @post.save                    
                    redirect_to users_posts_path
                else
                    @categories = Category.all
                    render 'users/edit_user_post', :id => @post.id
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
        #redirect_to root_path
       redirect_to not_found_path   
    end
end
