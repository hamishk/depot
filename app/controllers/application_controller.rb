class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :set_index_view_count

  private
  # let's initialize the view counter at zero
  def set_index_view_count
    if session[:index_visit_count].nil?
      session[:index_visit_count] = 0
    end
  end
end
