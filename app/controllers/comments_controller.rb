class CommentsController < ApplicationController
	before_action :find_post
	before_action :find_comment, only: [:destroy, :edit, :update]

	def create
		if user_signed_in? 
			@comment = @post.comments.create(params[:comment].permit(:message))
			@comment.user_id = current_user.id

			if @comment.save
				redirect_to post_path(@post)
			else
				render 'new'
			end
		end
	end	

	def destroy
		if user_signed_in?
			if @comment.user_id == current_user.id
				@comment.destroy
				redirect_to post_path(@post)
			else
				render 'new'
			end
		end
	end

	def edit		
	end

	def update
		if @comment.update(params[:comment].permit(:message))
			redirect_to post_path(@post)
		else
			render 'edit'
		end
	end

	private
	def find_post
		@post = Post.find(params[:post_id])
	end

	def find_comment
		@comment = @post.comments.find(params[:id])
	end
end
