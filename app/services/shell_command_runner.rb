class ShellCommandRunner
  def initialize(project, activity)
    @project = project
    @activity = activity
  end

  def run_command(command)
    terminal_command = <<-OSASCRIPT
      tell application "Terminal"
        if not (exists window 1) then reopen
        activate

        -- new tab
        tell application "System Events" to keystroke "t" using command down

        do script "#{command}" in window 1
      end tell
    OSASCRIPT

    system "osascript -e '#{terminal_command}'"
  end

  def run
    run_command("cd #{@project[:config][:path]} && #{@activity[:command]}")

    ActivityLog.create!({
      project_name: @project[:config][:name],
      activity_name: @activity[:name],
      params: {
      },
      activity_config: @activity
    })
  end
end
