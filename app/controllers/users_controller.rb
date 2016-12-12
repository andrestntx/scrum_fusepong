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
		@users = User.all
	end

	def show_developer
	end

	def account
		@user = current_user
		@projects = Project.report_by_user(current_user.id, month_now)
	end

	def calendar
	    events = []
	    @user.dailies.each do |daily|
	      events << {:id => daily.created_at, :title => "#{daily.sprint.project.name} - #{daily.comments}", 
	      	:start => "#{daily.time_start}", :end => "#{daily.time_end}", :allDay => daily.full? }
	    end
	    render :text => events.to_json
	end

	private 
		def set_user
			@user = User.find(params[:id])
		end

end
