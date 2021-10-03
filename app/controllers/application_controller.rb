class ApplicationController < ActionController::Base
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
