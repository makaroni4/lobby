class ActivitiesController < ApplicationController
  def index
    @projects = load_projects
    @activities = ActivityLog.all

    if flash[:open_in_vscode].present?
      @active_activity_log = ActivityLog.find(flash[:open_in_vscode])
    end
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

    camel_case_name = @name.include?(" ") ? @name.split(" ").map(&:camelize).join("") : @name
    snake_case_name = camel_case_name.underscore
    dash_name = snake_case_name.dasherize

    template = @activity[:template]
      .gsub("{{ name:dashed }}", dash_name)
      .gsub("{{ name:camelcased }}", camel_case_name)

    file_name = @activity[:filename]
      .gsub("{{ name:dashed }}", dash_name)
      .gsub("{{ name:camelcased }}", camel_case_name)

    new_file_path = File.join(
      @project[:config][:path],
      @activity[:target_folder],
      @folder,
      "#{file_name}.#{@activity[:extension]}"
    )

    File.open(new_file_path, "w") do |file|
      file.puts template
    end

    activity_log = ActivityLog.create!({
      project_name: @project[:config][:name],
      activity_name: @activity[:name],
      params: {
        name: params[:name],
        folder: params[:folder],
        file_path: new_file_path
      },
      activity_config: @activity
    })

    if params[:open_vscode] == "true"
      flash[:open_in_vscode] = activity_log.id
    end

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
