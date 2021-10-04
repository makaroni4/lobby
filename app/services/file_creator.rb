class FileCreator
  def initialize(project, activity, name, folder)
    @project = project
    @activity = activity
    @name = name
    @folder = folder.to_s
  end

  def create
    camel_case_name = @name.include?(" ") ? @name.split(" ").map(&:camelize).join("") : @name
    snake_case_name = camel_case_name.underscore
    dash_name = snake_case_name.dasherize

    files = @activity[:files].map do |file_params|
      template = file_params[:template]
        .gsub("{{ name:dashed }}", dash_name)
        .gsub("{{ name:camelcased }}", camel_case_name)

      pathname = file_params[:path]
        .gsub("{{ name:dashed }}", dash_name)
        .gsub("{{ name:camelcased }}", camel_case_name)

      new_file_path = File.join(
        @project[:config][:path],
        @activity[:target_folder],
        @folder,
        pathname
      )

      FileUtils.mkdir_p(File.dirname(new_file_path))

      File.open(new_file_path, "w") do |file|
        file.puts(template)
      end

      new_file_path
    end

    ActivityLog.create!({
      project_name: @project[:config][:name],
      activity_name: @activity[:name],
      params: {
        name: @name,
        folder: @folder,
        files: files
      },
      activity_config: @activity
    })
  end
end
