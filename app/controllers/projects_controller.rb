class ProjectsController < ApplicationController
  before_action :set_project, only: [:show_developer, :edit, :update, :destroy, :calendar]
  before_action :authenticate_user!
  before_action :filter_admin, except: [:index_developer, :show_developer]


  # Lista de proyectos que ve el developer
  def index_developer
    @projects = Project.all
  end

  # Vista de cada proyecto para los desarrolladores
  def show_developer
  end

  # Reporte del admin
  def index
    @projects = Project.all
  end

  def show
    @users    = User.report_by_project(params[:id], month_now)
    @project  = Project.report(month_now).find(params[:id])
  end

  def new
    @project = Project.new
  end

  def edit
  end

  # Crea un nuevo proyecto y asigna los usuarios que trabajarán en él.
  def create
    @project = Project.new(project_params)

    if @project.save
      @project.user_ids = params[:project]['user_ids']
      redirect_to @project, notice: 'Project was successfully created.'
    else
      redirect_to new_project_path(@project), alert: 'Errors: ' + @project.errors.full_messages.join(', ')
    end
  end

  def update
    if @project.update(project_params)
      @project.user_ids = params[:project]['user_ids']
      redirect_to @project, notice: 'Project was successfully created.'
    else
      redirect_to edit_project_path(@project), alert: 'Errors: ' + @project.errors.full_messages.join(', ')
    end
  end

  def destroy
    @project.destroy
    respond_to do |format|
      format.html { redirect_to projects_url, notice: 'Project was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def calendar
      events = []
      
      @project.sprints.each do |sprint|
        events << sprint.calendar

        sprint.sprint_productions.each do |production|
          events << production.calendar
        end

        sprint.dailies.each do |daily|
          events << daily.calendar_sprint
        end
      end

      render :text => events.to_json
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
