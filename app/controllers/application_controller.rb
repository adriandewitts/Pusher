class ApplicationController < ActionController::Base
  protect_from_forgery
 
  class InvalidToken < StandardError; end
  rescue_from InvalidToken, with: :access_denied

  
  def index
    render json: {ok: true}
  end
protected
  def current_app
    return nil unless params[:access_token]
    @current_app ||= App.where(access_token: params[:access_token]).first
  end
  
  def authorize_token!
    raise InvalidToken unless current_app
  end

  def access_denied
    render json: { error: 'Access Denied' }, status: 401    
  end
end
