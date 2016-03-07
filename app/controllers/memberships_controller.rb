class MembershipsController < ApplicationController
  before_action :set_membership, only: [:show, :confirm, :edit, :update, :destroy]
  before_action :ensure_that_user_is_member, only: [:confirm]
  # GET /memberships
  # GET /memberships.json
  def index
    @memberships = Membership.all
  end

  # POST /membership/:id/confirm
  def confirm
    ensure_that_user_is_member
    @membership.confirmed = true
    @membership.save
    redirect_to @membership.beer_club, notice: @membership.user.username + ' added to the club!'
  end


  # GET /memberships/1
  # GET /memberships/1.json
  def show
  end

  # GET /memberships/new
  def new
    @membership = Membership.new
    @beer_clubs = BeerClub.all
  end

  # GET /memberships/1/edit
  def edit
  end

  # POST /memberships
  # POST /memberships.json
  def create
    @users_memberships = Membership.where(user_id: current_user.id)
    @membership = Membership.new(membership_params)
    @membership.confirmed = false
    @already_member = @users_memberships.find_by(beer_club_id: @membership.beer_club_id)

    unless @already_member.nil?
      @membership.errors.set(:user_id, ["cannot be in same club twice"])
    end
    respond_to do |format|
      if @already_member.nil? && @membership.save

        current_user.memberships << @membership
        @beer_club = BeerClub.find(@membership.beer_club_id)
        @beer_club.memberships << @membership

        format.html { redirect_to @beer_club, notice: 'Your join request is sent to the club!' }
        format.json { render :show, status: :created, location: @membership }
      else
        @beer_clubs = BeerClub.all
        format.html { render :new }
        format.json { render json: @membership.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /memberships/1
  # PATCH/PUT /memberships/1.json
  def update
    respond_to do |format|
      if @membership.update(membership_params)
        @beer_club = BeerClub.find(@membership.beer_club_id)
        format.html { redirect_to @beer_club, notice: 'Membership was successfully updated.' }
        format.json { render :show, status: :ok, location: @membership }
      else
        format.html { render :edit }
        format.json { render json: @membership.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /memberships/1
  # DELETE /memberships/1.json
  def destroy
    @club = @membership.beer_club
    @membership.destroy
    respond_to do |format|
      format.html { redirect_to current_user, notice: 'Membership ' + @club.name + ' in club ended.' }
      format.json { head :no_content }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_membership
    @membership = Membership.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def membership_params
    params.require(:membership).permit(:beer_club_id)
  end

  def ensure_that_user_is_member
    current_users_membership = Membership.find_by(user: current_user, beer_club: @membership.beer_club)
    if current_users_membership.nil? or !current_users_membership.confirmed
      redirect_to :back, notice: 'only members of club can do that'
    end
  end
end
