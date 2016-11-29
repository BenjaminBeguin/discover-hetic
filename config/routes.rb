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
    get 'posts/update'
    get 'posts/vote'

    get 'posts/index'
    get 'posts/:slug' => "posts#category"

    resources :posts
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
