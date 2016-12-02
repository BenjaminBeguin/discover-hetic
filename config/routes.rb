Rails.application.routes.draw do


    #-------------- Vote -------------#

    #resources :votes

    #-------------- Categorie -------------#

    get 'categories/'  => "categories#index"
    post 'categories/create'

    get 'categories/new'

    root 'posts#index' #home

    #-------------- COMMENTS -------------#

    resources :comments
    
    #-------------- POST -------------#
    
    get 'posts/index'
    get 'posts' => "posts#index"
    get 'posts/new'
    get 'posts/vote'
    get 'search' => "posts#search", as: :posts_search
    post 'posts/post_comment'
    get 'category/:slug' => "posts#category", :as => :category

    post 'posts/unpublish/:id' => "posts#unpublish!", :as => :posts_unpublished 
    post 'posts/publish/:id' => "posts#publish!", :as => :posts_published 
    post 'posts/vote/:id' => "posts#vote", :as => :posts_add_vote
    patch 'posts/update/:id' => "posts#update", as: :posts_update


    resources :posts do
        resources :comments, :only => [:create, :destroy, :update, :edit]
    end

    #-------------- USER -------------#

    devise_for :users, controllers: {
        registrations: 'users/registrations',
        sessions: 'users/sessions'
    }

    devise_scope :user do
        put 'users/upload', to: 'devise/registrations#upload', as: :upload
    end
      
    get 'users/' => 'users#index'
    get 'users/posts' => 'users#get_user_post'
    get 'users/posts/:id' => 'users#edit_user_post' , :as => :users_posts_id 
    get 'users/:slug' => "posts#by_user", as: :posts_by_user

    #----------------------------------#

   # get "*path" => redirect("/")

end
