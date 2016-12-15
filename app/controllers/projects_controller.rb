class ProjectsController < ApplicationController
  before_action :set_project, only: [:show_developer, :edit, :update, :destroy]
  before_action :authenticate_user!
  before_action :filter_admin, except: [:index_developer, :show_developer]
  

  # GET /projects
  # GET /projects.json
  def index
    @projects = Project.report(month_now)
  end

  def index_developer
    @projects = Project.all
  end

  # GET /projects/1
  # GET /projects/1.json
  def show
    @users    = User.report_by_project(params[:id], month_now)
    @project  = Project.report(month_now).find(params[:id])
  end

  def show_developer
  end

  # GET /projects/new
  def new
    @project = Project.new
  end

  # GET /projects/1/edit
  def edit
  end

  # POST /projects
  # POST /projects.json
  def create
    @project = Project.new(project_params)

    if @project.save
      @project.user_ids = params[:project]['user_ids']
      redirect_to @project, notice: 'Project was successfully created.'
    else
      redirect_to new_project_path(@project), alert: 'Errors: ' + @project.errors.full_messages.join(', ')
    end
  end

  # PATCH/PUT /projects/1
  # PATCH/PUT /projects/1.json
  def update
    if @project.update(project_params)
      @project.user_ids = params[:project]['user_ids']
      redirect_to @project, notice: 'Project was successfully created.'
    else
      redirect_to edit_project_path(@project), alert: 'Errors: ' + @project.errors.full_messages.join(', ')
    end
  end

  # DELETE /projects/1
  # DELETE /projects/1.json
  def destroy
    @project.destroy
    respond_to do |format|
      format.html { redirect_to projects_url, notice: 'Project was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_project
      @project = Project.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def project_params
      params.require(:project).permit(:name, :description, :client, :started_at, :calculated_sprints, :color)
    end
end
