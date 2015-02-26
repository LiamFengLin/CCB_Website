class ApiController < ApplicationController

  respond_to :json
  before_action :default_json

  before_filter :authenticate_user_from_token!

  def current_user
    auth_token = params[:auth_token]
    return nil unless auth_token
    User.find_by authentication_token: auth_token
  end

  protected

  def default_json
    request.format = :json if params[:format].nil?
  end

  def auth_only!
    render json: {}, status: 401 unless current_user
  end

  private 

  def authenticate_user_from_token!
    user_email = params[:email].presence
    user = user_email && User.find_by_email(user_email)

    if user && Devise.secure_compare(user.authentication_token, params[:auth_token])
      sign_in user, store: false
    end
  end
end