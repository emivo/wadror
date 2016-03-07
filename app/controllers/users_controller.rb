class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy, :toggle_froze]
  before_action :ensure_that_user_is_current_user, only: [:edit, :update, :destroy]
  before_action :ensure_that_user_is_admin, only: [:toggle_froze]

  # GET /users
  # GET /users.json
  def index
    @users = User.includes(:beers, :ratings).all
  end

  # GET /users/1
  # GET /users/1.json
  def show
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
    if @user.password_digest.nil?
      redirect_to @user, notice: 'You cannot set password for Github account'
    end
  end

  # POST
  def toggle_froze
    @user.update_attribute(:active, !@user.active)
    if @user.active
      message = 'Account reactivated'
    else
      message = 'Account frozen'
    end
    redirect_to users_path, notice: message
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)
    @user.active = true

    respond_to do |format|
      if @user.save
        format.html { redirect_to @user, notice: 'User was successfully created.' }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    respond_to do |format|
      if current_user != @user
        redirect_to :back, notice: @user.username + "is not signin"
      end
      if user_params[:username].nil? && current_user == @user && @user.update(user_params)
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit, notice: 'Something went wrong' }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy if current_user == @user
    respond_to do |format|
      session[:user_id] = nil
      format.html { redirect_to root_path, notice: 'User was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = User.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def user_params
    params.require(:user).permit(:username, :password, :password_confirmation)
  end

  def ensure_that_user_is_current_user
    redirect_to @user, notice: 'only user it self can do that' if current_user != @user
  end
end
