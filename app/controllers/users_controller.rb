class UsersController < ApiController

  before_action :auth_only!

  def index
    if params[:ids]
      @users = User.find params[:ids]
    else
      @users = User.all
    end
    render json: @users
  end

  def show
    @user = User.find params[:id]
    render json: UserSerializer.new(@user)
  end
end