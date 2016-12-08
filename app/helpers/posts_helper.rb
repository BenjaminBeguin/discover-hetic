module PostsHelper


	def order_by_class_for(order)
		if order == "top"
			return params[:orderby] == order ? "active" : ""
		end
		if order == "" && !params[:orderby] 
			return "active"
		end
	end

	def order_by_class_for_user(order)
		if order == "voted"
			return params[:mypost] == order ? "active" : ""
		end
		if order == "" && !params[:mypost] 
			return "active"
		end
	end
end
