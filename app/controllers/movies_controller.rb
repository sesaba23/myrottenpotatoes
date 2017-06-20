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
    # This instance variable is share for MoviesHelper class. 
    @ordered_by = params[:order_by] if params.has_key? 'order_by'

    # Instance variable that holds all posible values (distinct) in the field rating
    @all_ratings = Movie.get_list_of_ratings

    # Get hash 'rating' from hash 'params' only if the user has selected some checkbox
    @checked_ratings = params[:ratings] if params.has_key? 'ratings'
       
    # save  the state of each rating checkbox in order to be able to use in the next HTML request
    #session[:checked_ratings] = @checked_ratings if @checked_ratings
    #if !@checked_ratings && session[:checked_ratings] 
    #  @checked_ratings = session[:checked_ratings] unless @checked_ratings
    #end

    # If we had set an ':order_by' value in hash params[] order de list
  	if params[:order_by] ==  'title'
      @movies = Movie.order('title asc')
    end	
    if params[:order_by] = 'release_date'
      @movies = Movie.order('release_date asc') 
    end
    if @checked_ratings
      array = @checked_ratings.keys
      @movies = Movie.where(rating:  array) 
  	else
      @movies = Movie.all
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
