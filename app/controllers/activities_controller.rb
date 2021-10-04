class ActivitiesController < ApplicationController
  before_action :load_project_and_activity

  def new
    if @activity[:type] == "shell_command"
      process_shell_command_activity

      flash[:notice] = "Shell command is running, check out your Terminal."
      redirect_to project_path(id: @project[:config][:slug])
      return
    end
  end

  def create
    if @activity[:type] == "create_file"
      process_create_file_activity

      flash[:notice] = "File was created."
    elsif @activity[:type] == "shell_command"
      process_shell_command_activity

      flash[:notice] = "Shell command is running, check out your Terminal."
    end

    redirect_to project_path(id: @project[:config][:slug])
  end

  private

  def load_project_and_activity
    projects = load_projects

    @project = projects.values.find { |project| project[:config][:name] == params[:project_name] }
    @activity = @project[:activities].find { |activity| activity[:name] == params[:activity_name] }
  end

  def process_create_file_activity
    activity_log = FileCreator.new(@project, @activity, params[:name], params[:folder]).create

    if params[:open_vscode] == "true"
      flash[:open_in_vscode] = activity_log.id
    end
  end

  def process_shell_command_activity
    ShellCommandRunner.new(@project, @activity).run
  end
end
