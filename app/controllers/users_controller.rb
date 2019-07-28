class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  before_action :admin_user, except: [:index, :show]
  before_action :set_patients, only: [:index, :show]

  def index
    if current_user.user_type.name == "Patient"
      @users = User.where.not(id: current_user) - @patients
    else
      @users = User.all
    end
  end

  # GET /products/1
  # GET /products/1.json
  def show
    if current_user.user_type.name == "Patient" && @user.user_type.name == "Patient"
      flash[:notice] = "User does not exist."
      redirect_back(fallback_location: root_path)
    else
      @login_activities = LoginActivity.where(identity: @user.email)
    end
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

    def set_patients
      @patients = User.joins(:user_type).where(user_types: {name: 'Patient'})
    end

    # Confirms an admin user.
    def admin_user
      redirect_back(fallback_location: root_path) unless current_user.admin?
    end

    def user_params
       params.require(:user).permit(:email, :password, :password_confirmation, 
                                    :admin, :deleted_at, :title, :first_name, 
                                    :middle_name, :last_name, :date_of_birth,
                                    :cell_phone, :secondary_phone, :fax, 
                                    :street, :city, :province, :postal, :country,
                                    :disabled, :user_type_id)
    end
end
