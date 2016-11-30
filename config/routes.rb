Rails.application.routes.draw do



  get 'categories/'  => "categories#index"
  post 'categories/create'

  get 'categories/new'

    root 'posts#index' #home

    #-------------- COMMENTS -------------#

    resources :comments
    
    get 'comments/index'

    get 'comments/new'



    #-------------- POST -------------#
    

    get 'posts' => "posts#index"
    get 'posts/new'
    patch 'posts/update/:id' => "posts#update", as: :posts_update
    get 'posts/vote'
    post 'posts/post_comment'

    post 'posts/unpublish/:id' => "posts#unpublish!", :as => :posts_unpublished 
    post 'posts/publish/:id' => "posts#publish!", :as => :posts_published 

    get 'posts/index'
    get 'category/:slug' => "posts#category"

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


    #----------------------------------#

end
