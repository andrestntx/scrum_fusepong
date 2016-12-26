class MobileController < ApplicationController
	before_action :authenticate_user!
	
	def index
		
	end

	def team
		@user = User.find(params[:id])
		@new_daily = @user.dailies.build
	end

	def projects
		@project  = Project.find(params[:id])
	end


	private
		
end
