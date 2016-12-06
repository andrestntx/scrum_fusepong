class SprintsController < ApplicationController
	def create
	    @project = Project.find(params[:project_id])
	    @sprint = @project.sprints.create(sprint_params)
	    redirect_to project_path(@project)
	end
 
	def show
		@project = Project.find(params[:project_id])
	    @sprint = @project.sprints.find(params[:id])
	end

	private
	    def sprint_params
	      params.require(:sprint).permit(:started_at, :weeks, :number)
	    end
end
