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

	# Permite crear un nuevo daily al usuario actualmente logueado
	def account
		@user = current_user
		@projects = Project.report_by_user(current_user.id, month_now)
		@new_daily = @user.dailies.build
	end

	def calendar
	    events = []

	    @user.dailies.each do |daily|
	      	events << daily.calendar_user
	    end

	    sprints = Sprint.joins(project: :users).where("projects_users.user_id = #{@user.id}").group("sprints.id")

	    sprints.each do |sprint|
			events << sprint.calendar

			sprint.sprint_productions.each do |production|
				events << production.calendar_user
			end
	    end

	    render :text => events.to_json
	end

	private 
		def set_user
			@user = User.find(params[:id])
		end

end
