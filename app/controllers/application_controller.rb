class ApplicationController < ActionController::Base
 require 'jwt_token'
  # skip_forgery_protection  
  # before_action :authenticate_user
  # Authentication
  def authenticate_user
      token = request.headers['token']
      if token
        decoded_token = JwtToken.decode_token(token)
          @current_user = UserBlock::User.find_by(id: decoded_token[0]['user_id'])
           render json: { message: 'User not found' }, status: :not_found unless @current_user
           return @current_user if @current_user
      else
        render json: { message: 'Token not found' }, status: :unauthorized
      end
  end

	rescue_from StandardError, with: :handle_exception
	
  private
 
  def handle_exception(exception)
    render json: { error: exception.message }, status: :internal_server_error
  end
end

