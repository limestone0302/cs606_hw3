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

    if params[:sort]
      session[:sort] = params[:sort]
    elsif session[:sort]
      params[:sort] = session[:sort]
      flash.keep
      redirect_to movies_path(params) and return
    end
    
    sort_by = session[:sort]
    
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
    
    @movies = Movie.all.order(sort_by).where(rating: @checked_ratings)
    
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
