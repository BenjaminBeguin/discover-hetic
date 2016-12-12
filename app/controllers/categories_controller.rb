class CategoriesController < ApplicationController
   
    # Route deleted
    def index
        @categories = Category.all;
    end

    def new
        @category = Category.new
    end

    def create
        @category = Category.new(label: params[:category][:label])
        if @category.save
            redirect_to action: "index"
        else
            render :new
        end
    end
end
