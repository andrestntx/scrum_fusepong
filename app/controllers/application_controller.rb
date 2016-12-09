class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  protected
  	def filter_role (role, redirect_path)
  		if(current_user.role != role)
  			redirect_to redirect_path 
  		end
  	end

  	def filter_admin
  		filter_role 'admin', projects_developer_path
  	end

  	def filter_developer
  		filter_role 'developer', projects_path
  	end
end
