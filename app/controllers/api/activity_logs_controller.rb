module Api
  class ActivityLogsController < ApplicationController
    before_action :load_activity_log

    def open_in_vscode
      files = @activity_log.params["files"]

      command = <<-BASH
        code #{@project[:config][:path]} #{files.join(" ")}
      BASH

      system command

      head :ok
    end

    private

    def load_activity_log
      @activity_log = ActivityLog.find(params[:activity_log_id])
      @project = load_projects.values.find { |project| project[:config][:name] == @activity_log.project_name }
    end
  end
end
