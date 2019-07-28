class UserTypesController < ApplicationController
  before_action :set_user_type, only: [:show, :edit, :update, :destroy]
  before_action :set_system_user_types

  # GET /user_types
  # GET /user_types.json
  def index
    @user_types = UserType.all
  end

  # GET /user_types/1
  # GET /user_types/1.json
  def show
  end

  # GET /user_types/new
  def new
    @user_type = UserType.new
  end

  # GET /user_types/1/edit
  def edit
    if @system_user_types.include?(@user_type.name)
      redirect_to user_types_path, notice: 'User type cannot be edited.'
    end
  end

  # POST /user_types
  # POST /user_types.json
  def create
    @user_type = UserType.new(user_type_params)

    respond_to do |format|
      if @user_type.save
        format.html { redirect_to @user_type, notice: 'User type was successfully created.' }
        format.json { render :show, status: :created, location: @user_type }
      else
        format.html { render :new }
        format.json { render json: @user_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /user_types/1
  # PATCH/PUT /user_types/1.json
  def update
    if @system_user_types.exclude?(@user_type.name)
      respond_to do |format|
        if @user_type.update(user_type_params)
          format.html { redirect_to user_types_path, notice: 'User type was successfully updated.' }
          format.json { render :show, status: :ok, location: @user_type }
        else
          format.html { render :edit }
          format.json { render json: @user_type.errors, status: :unprocessable_entity }
        end
      end
    else
      redirect_to user_types_path, notice: 'User type cannot be edited.'
    end
  end

  # DELETE /user_types/1
  # DELETE /user_types/1.json
  def destroy
    respond_to do |format|
      if @system_user_types.include?(@user_type.name)
        format.html { redirect_to user_types_path, notice: 'User type cannot be destroyed.' }
      elsif @user_type.users.exists?
        format.html { redirect_to user_types_path, notice: 'Cannot delete user type while being used.' }
      else
        @user_type.destroy
          format.html { redirect_to user_types_path, notice: 'User type was successfully destroyed.' }
          format.json { head :no_content }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user_type
      @user_type = UserType.find(params[:id])
    end

    def set_system_user_types
      @system_user_types = ["Patient", "Physician", "Professional", "Institution"]
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_type_params
      params.require(:user_type).permit(:name)
    end
end
