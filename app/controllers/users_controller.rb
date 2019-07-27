class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  before_action :admin_user, except: [:index, :show]
  def index
    @users = User.all
  end

  # GET /products/1
  # GET /products/1.json
  def show
    @login_activities = LoginActivity.where(identity: @user.email)
  end

  def edit
  end

  def update
    params[:user].delete(:password) if params[:user][:password].blank?
    params[:user].delete(:password_confirmation) if params[:user][:password].blank? and params[:user][:password_confirmation].blank?
    
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
      else
        format.html { render :edit }
      end
    end
  end

  def destroy
    if @user.destroy
      flash[:notice] = "Successfully deleted User."
      redirect_back(fallback_location: root_path)
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Confirms an admin user.
    def admin_user
      redirect_back(fallback_location: root_path) unless current_user.admin?
    end

    def user_params
       params.require(:user).permit(:email, :password, :password_confirmation, 
                                    :admin, :deleted_at, :title, :first_name, 
                                    :middle_name, :last_name, :cell_phone, 
                                    :secondary_phone, :fax, :street, :city, 
                                    :province, :postal, :country, :disabled)
    end
end
