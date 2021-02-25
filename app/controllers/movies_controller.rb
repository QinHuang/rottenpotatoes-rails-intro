class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_rankings = Movie.all_rankings
    

  order = params[:sort] || session[:sort]
  @rankings_to_display = params[:ratings] || session[:ratings] || Hash[@all_rankings.map { |r| [r,1] }]
  
  if !params[:commit].nil? or params[:ratings].nil? or (params[:sort].nil? && !session[:sort].nil?)
     flash.keep
     redirect_to movies_path :ratings => @rankings_to_display, :sort => order
  end
  
  if order == 'release_date'
     queue = {:release_date => :asc}
     @release_cls = 'hilite bg-warning'
  elsif order == 'title'
     queue = {:title => :asc}
     @title_cls = 'hilite bg-warning'
  end 
  
  session[:ratings]=@rankings_to_display
  session[:sort] = order
  @movies = Movie.on_rankings(@rankings_to_display.keys).order(queue)
    
  
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
