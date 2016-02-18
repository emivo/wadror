class PlacesController < ApplicationController

  def index
  end

  def show
    @places = BeermappingApi.places_in(session[:last_city])
    for temp in @places
       if temp.id == params[:id]
           @place = temp
       end
    end
  end

  def search
    @places = BeermappingApi.places_in(params[:city])
    session[:last_city] = params[:city]
    if @places.empty?
      redirect_to places_path, notice: "No locations in #{params[:city]}"
    else
      render :index
    end
  end
end