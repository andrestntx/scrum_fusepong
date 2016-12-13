class UsersController < ApplicationController
	before_action :authenticate_user!
	before_action :filter_admin, except: [:index_developer, :show_developer, :account, :calendar]
	before_action :set_user, only: [:show, :show_developer, :calendar]
	
	def index
		@users = User.report(month_now)
	end

	def show
		@projects = Project.report_by_user(params[:id], month_now)
	end

	def index_developer
		@users = User.role('developer')
	end

	def show_developer
	end

	def account
		@user = current_user
		@projects = Project.report_by_user(current_user.id, month_now)
	end

	def calendar
	    events = []

	    

	    sprints = Sprint.joins(:users, :project).where("users.id = 1").references(:users).group("sprints.id")
	    sprints.each do |sprint|
	      events << sprint.calendar
	    end


	    render :text => events.to_json
	end

	private 
		def set_user
			@user = User.find(params[:id])
		end

end
