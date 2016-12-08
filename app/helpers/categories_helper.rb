module CategoriesHelper

	def class_for_active_menu(category)
		if params[:slug] == category
			return "active"
		end
	end
end
