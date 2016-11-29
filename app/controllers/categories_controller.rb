class CategoriesController < ApplicationController
  def index
  	 @categories = Category.all;
  end

  def new
  	@category = Category.new
  end

  def create
	@category = Category.new(
        label: params[:category][:label]
	)
	@category.save
	redirect_to action: "index"
  end

    
end
