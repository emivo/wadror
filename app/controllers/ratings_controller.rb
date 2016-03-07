class RatingsController < ApplicationController
  def index
    # SQL-kyselyiden määrä pudotettu n. 1100 => n. 40
    # sitten vielä cachaus, tuskin auttaa paljoakaan verrattuna SQL parannukseen
    # @ratings = Rails.cache.fetch('ratings', expires_in: 3.minutes) { Rating.all }
    @recent = Rails.cache.fetch('recent', expires_in: 3.minutes) { Rating.recent }
    @top_raters = Rails.cache.fetch('top_raters', expires_in: 3.minutes) { User.top 3 }
    @top_breweries = Rails.cache.fetch('top_breweries', expires_in: 3.minutes) { Brewery.top 3 }
    @top_beers = Rails.cache.fetch('top_beers', expires_in: 3.minutes) { Beer.top 3 }
    @top_styles = Rails.cache.fetch('top_styles', expires_in: 3.minutes) { Style.top 3 }

  end
  def new
    @rating = Rating.new
    @beers = Beer.all
  end

  def create
    @rating = Rating.new params.require(:rating).permit(:score, :beer_id)
    if current_user.nil?
      redirect_to signin_path, notice: 'you should be signed in'
    elsif @rating.save
      current_user.ratings << @rating
      redirect_to user_path current_user
    else
      @beers = Beer.all
      render :new
    end
  end

  def destroy
    rating = Rating.find(params[:id])
    rating.delete if current_user == rating.user
    redirect_to :back
  end
end