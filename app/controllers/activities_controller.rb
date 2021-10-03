class ActivitiesController < ApplicationController
  def index
    @projects = load_projects
    @activities = ActivityLog.all
  end

  def new
    projects = load_projects

    @project = projects.values.find { |project| project[:config][:name] == params[:project_name] }
    @activity = @project[:activities].find { |activity| activity[:name] == params[:activity_name] }
  end

  def create
    projects = load_projects

    @project = projects.values.find { |project| project[:config][:name] == params[:project_name] }
    @activity = @project[:activities].find { |activity| activity[:name] == params[:activity_name] }

    @name = params[:name]
    @folder = params[:folder].to_s

    new_file_path = File.join(
      @project[:config][:path],
      @activity[:target_folder],
      @folder,
      "#{@name}.#{@activity[:extension]}"
    )

    File.open(new_file_path, "w") do |file|
      file.puts @activity[:template]
    end

    ActivityLog.create!({
      project_name: @project[:config][:name],
      activity_name: @activity[:name],
      params: {
        name: params[:name],
        folder: params[:folder],
        file_path: new_file_path
      },
      activity_config: @activity
    })

    redirect_to activities_path, notice: "Created"
  end

  private

  def project_folders
    Rails.root.join("projects").glob("*").select { |f| File.directory?(f) }
  end

  def load_projects
    projects = {}

    project_folders.each do |folder|
      config = YAML.load File.read File.join(folder, "config.yml")
      activities = Rails.root.join(folder, "activities").glob("*.yml").map do |activity_config|
        YAML.load File.read(activity_config)
      end

      projects[config[:name]] = {
        config: config,
        activities: activities
      }
    end

    projects
  end
end
