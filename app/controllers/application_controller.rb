class ApplicationController < ActionController::Base
    # Prevent CSRF attacks by raising an exception.
    # For APIs, you may want to use :null_session instead.

    
    protect_from_forgery with: :exception
    before_filter :set_current_user
    before_filter :all_categories

    POST_PER_PAGE = 10;

    def all_categories
        @categories = Category.all
    end

    def set_current_user
        Post.current_user = current_user
    end
end
