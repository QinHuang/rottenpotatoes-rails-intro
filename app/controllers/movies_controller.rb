class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_rankings = Movie.all_rankings
    
    if params[:ratings]
      @rankings_to_display = params[:ratings].keys
    else
      @rankings_to_display = []
    end 
    @movies = Movie.on_rankings(@rankings_to_display)
    
    #part_1
    order = params[:sort]
    if order != nil
      @rankings_to_display = params[:selected_ratings]
      if order == 'date'
        @movies, @date_class = Movie.on_rankings(params[:selected_ratings]).order(release_date: :asc), 'hilite bg-warning'
      elsif order = 'title'
        @movies, @title_class = Movie.on_rankings(params[:selected_ratings]).order(title: :asc), 'hilite bg-warning'
      end
    end
    
#    @movies = Movie.all
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

  private
  # Making "internal" methods private is not required, but is a common practice.
  # This helps make clear which methods respond to requests, and which ones do not.
  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end
end
