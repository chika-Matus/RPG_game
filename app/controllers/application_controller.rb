class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  
  private
  
  def current_player
    @current_player ||= Player.find(session[:player_id]) if session[:player_id]
  end
  
  def require_player
    redirect_to root_path unless current_player
  end
  
  helper_method :current_player
end