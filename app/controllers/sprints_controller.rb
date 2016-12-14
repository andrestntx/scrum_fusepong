class SprintsController < ApplicationController
	before_action :authenticate_user!
	before_action :filter_admin, except: [:show_developer, :calendar]
	before_action :set_sprint, only: [:calendar, :edit, :update]

	def create
	    project = Project.find(params[:project_id])
	    sprint = project.new_sprint(sprint_params)
	    sprint.add_productions(sprint_productions)

	    redirect_to project_path(project)
	end
 
	def show
		@project = Project.find(params[:project_id])
		@sprint = Sprint.report(month_now).find(params[:id])
		@users = User.report_by_sprint(@project.id, @sprint.id, month_now)
	end

	def show_developer
		@project = Project.find(params[:project_id])
		@sprint = Sprint.report(month_now).find(params[:id])
		@users = User.report_by_sprint(@sprint.id, month_now)
	end

	# GET /projects/1/edit
	def edit
	end

	def create
	    project = Project.find(params[:project_id])
	    sprint = project.new_sprint(sprint_params)
	    sprint.add_productions(sprint_productions)

	    redirect_to project_path(project)
	end

	# PATCH/PUT /projects/1
	def update
	    if @sprint.update(sprint_params)
	    	@sprint.update_productions(sprint_productions)
			redirect_to project_sprint_path, notice: 'Sprint was successfully updated.'
		else
			redirect_to project_sprint_path, alert: 'Error'
		end
	end

	def calendar
	    events = []
	    
	    @sprint.dailies.each do |daily|
	      events << daily.calendar_sprint
	    end

	    @sprint.sprint_productions.each do |production|
	      events << production.calendar
	    end

	    events << @sprint.calendar

	    render :text => events.to_json
	end

	private
	    def sprint_params
	      params.require(:sprint).permit(:started_at, :weeks, :number)
	    end

	    def sprint_productions
	    	params[:sprint][:sprint_productions][:date].split(",")
	    end

	    def set_sprint
	    	@project = Project.find(params[:project_id])
			@sprint = @project.sprints.find(params[:id])
		end
end
