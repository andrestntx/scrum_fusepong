class UsersController < ApplicationController
	before_action :authenticate_user!
	before_action :filter_admin, except: [:index_developer, :show_developer]
	
	def index
		@users = User.all
	end

	def show
		@user = User.find(params[:id])
	end

	def index_developer
		@users = User.all
	end

	def show_developer
		@user = User.find(params[:id])
	end
end
