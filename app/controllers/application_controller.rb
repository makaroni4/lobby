class ApplicationController < ActionController::Base
  helper_method :load_projects

  private

  def load_projects
    ProjectsLoader.new.load_projects
  end
end
