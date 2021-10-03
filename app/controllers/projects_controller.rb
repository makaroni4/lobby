class ProjectsController < ApplicationController
  def index
    @projects = load_projects
  end

  def show
    projects = load_projects

    @project = projects.values.find { |project| project[:config][:slug] == params[:id] }
    @activities = ActivityLog.where(project_name: @project[:config][:name])
  end
end
