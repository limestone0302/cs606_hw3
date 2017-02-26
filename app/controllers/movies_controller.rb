class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings = Movie.all_ratings

    if params[:title] == "sort"
      session[:title] = params[:title]
      session[:release_date] = nil
    elsif params[:release_date] == "sort"
      session[:release_date] = params[:release_date]
      session[:release_date] = nil
    elsif session[:title]
      params[:title] = session[:title]
      session[:release_date] = nil
       flash.keep
      redirect_to movies_path(params) and return
    elsif session[:release_date]
      params[:release_date] = session[:release_date]
      session[:title] = nil
       flash.keep
      redirect_to movies_path(params) and return
    end
    
    sort_by_title = params[:title]
    sort_by_release_date = params[:release_date]

    if params[:ratings]
      session[:ratings] = params[:ratings]
      @checked_ratings = session[:ratings].keys
    elsif session[:ratings]
      params[:ratings] = session[:ratings]
      @checked_ratings = session[:ratings].keys
       flash.keep
      redirect_to movies_path(params) and return
    else
      @checked_ratings = @all_ratings
    end
    
    if sort_by_title == "sort"
        @movies = Movie.all.order(:title => "ASC").where(rating: @checked_ratings)
    elsif sort_by_release_date == "sort"
        @movies = Movie.all.order(:release_date => "ASC").where(rating: @checked_ratings)
    else
        @movies = Movie.all.where(rating: @checked_ratings)
    end
  end
  
  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end
