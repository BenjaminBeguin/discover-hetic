Rails.application.routes.draw do

    root 'welcome#index' #home

    #-------------- POST -------------#
    
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

    #----------------------------------#

end
