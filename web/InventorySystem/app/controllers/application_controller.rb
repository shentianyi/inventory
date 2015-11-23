class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :set_current_controller_and_action

  def set_current_controller_and_action
    @current_controller=self.controller_name
    @current_action=self.action_name
  end
end
