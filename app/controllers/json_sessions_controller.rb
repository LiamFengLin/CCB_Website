class JsonSessionsController < Devise::SessionsController
  def create
    params[:user].merge!(remember_me: 1)
    respond_to do |format|
      format.html { super }
      format.json {
        warden.authenticate!(:scope => resource_name, :recall => "#{controller_path}#new")
        render :status => 200, :json => { :error => "Success" }
      }
    end
  end

  def destroy
    super
  end
end