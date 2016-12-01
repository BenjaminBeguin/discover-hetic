class PostsController < ApplicationController
    def index
        if params[:orderby] == 'top'
            @posts = Post.paginate(:page => params[:page], :per_page => 10).order('vote DESC')
        else
            @posts = Post.paginate(:page => params[:page], :per_page => 10).order('id DESC')
        end
        @post_voted = post_like_unlike

        @day = Date.yesterday
        @top_post = top_of_the_day(@day);
        @best_users = get_best_users
    end
    
    def top_of_the_day(date)
        Post.where(created_at: date.midnight..date.end_of_day).order(vote: :desc).first
    end

    def get_best_users
        @all_user = User.order(vote_count: :desc).limit(5)
    end

    def show
        @post = Post.find_by_id(params[:id]) or not_found
        @comments = Comment.where(post_id: params[:id]).order(created_at: :desc)
    end

    def search
        if params[:q]
            if params[:orderby] == 'newest'
                @posts = Post.search(params[:q]).paginate(:page => params[:page], :per_page => 10).order('created_at DESC')
            else
                @posts = Post.search(params[:q]).paginate(:page => params[:page], :per_page => 10).order('vote DESC')
            end
        else
            if params[:orderby] == 'newest'
                @posts = Post.paginate(:page => params[:page], :per_page => 10).order('created_at DESC')
            else
                @posts = Post.paginate(:page => params[:page], :per_page => 10).order('vote DESC')
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
                @posts = Post.paginate(:page => params[:page], :per_page => 10).where(category_id: @category.id).order(vote: :desc)
            else
                @posts = Post.paginate(:page => params[:page], :per_page => 10).where(category_id: @category.id).order(created_at: :desc)
            end
            post_like_unlike
            #--- get the first by vote --#
            date = Date.yesterday
            @top_post = Post.where(category_id: @category.id, created_at: date.midnight..date.end_of_day).order(vote: :desc).first
        else
            redirect_to action: "index"
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
        end
    end

    def by_user
        @user_slug = params[:slug];
        @user = User.where(slug: @user_slug).first

        if  @user.present?
            if params[:orderby] == 'top'
                @posts = Post.where(user_id: @user.id).order(vote: :desc)
            else
                @posts = Post.where(user_id: @user.id).order(created_at: :desc)
            end
            post_like_unlike
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
        @connected = user_signed_in?
        if @connected
            @post = Post.find(params[:id])
            @already_voted = Vote.where(user_id: current_user.id , post_id: @post.id);
            if @already_voted.empty?
                @post.update(vote: @post.vote + 1)
                @post.save
                @vote = Vote.create(user_id: current_user.id , post_id: @post.id)

                redirect_to posts_path 
            else
                @post.update(vote: @post.vote - 1)
                @post.save
                Vote.destroy(@already_voted.first.id)
                
                redirect_to posts_path 
            end
        else
            redirect_to new_user_session_path 
        end
    end

    def new
        @connected = user_signed_in?
        date = Time.now;
        if @connected
            #@has_voted = Post.where(created_at: date.midnight..date.end_of_day, user_id: current_user.id).first
            if @has_voted.blank?
                @post = Post.new
                @categories = Category.all;
            else
                render json: @has_voted;
            end
        else
            flash[:error] = 'You need to be login to post'
            redirect_to action: "index"
        end

    end



    def create
        @connected = user_signed_in?
        if @connected
            @post = Post.new(params.require(:post).permit(:title, :category_id, :url, :content));
            @post.user_id = current_user.id 
            if @post.save 
                redirect_to action: "index"
            else
                @categories = Category.all;
                render :new  
            end
        end
    end

    def update
        @connected = user_signed_in?
        if @connected
            @post = Post.find(params[:post][:id])
            if @post.user_id = current_user.id
                @post.update(params.require(:post).permit(:title, :category_id, :url, :content));
                
                @post.update(
                    title: params[:post][:title],
                    category_id: params[:post][:category_id],
                    url: params[:post][:url],
                    content: params[:post][:content],
                    asset: params[:post][:asset]
                    )
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
        redirect_to root_path
       # render file: "#{Rails.root}/public/404.html", layout: false, status: 404    
    end
end
