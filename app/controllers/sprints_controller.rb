class SprintsController < ApplicationController
	before_action :authenticate_user!
	before_action :filter_admin, except: [:show_developer]

	def create
	    @project = Project.find(params[:project_id])
	    @sprint = @project.sprints.create(sprint_params)

	    params[:sprint][:sprint_productions][:date].split(",").each do |date|
		   production = @sprint.sprint_productions.new()
		   production.date = date 
		   production.save()
		end

	    redirect_to project_path(@project)
	end
 
	def show
		@project = Project.find(params[:project_id])
	    @sprint = @project.sprints.find(params[:id])
	end

	def show_developer
		@project = Project.find(params[:project_id])
	    @sprint = @project.sprints.find(params[:id])
	end

	private
	    def sprint_params
	      params.require(:sprint).permit(:started_at, :weeks, :number)
	    end
end
