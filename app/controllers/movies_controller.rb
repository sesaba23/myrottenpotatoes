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

    # Instance variable that holds all posible values (distinct) in the column rating of the DB
    # in order to load 'rating filter' in the view
    @all_ratings = Movie.get_list_of_ratings

    # Get hash 'rating' from hash 'params' only if the user has selected some checkbox
    @checked_ratings = params[:ratings] if params.has_key? 'ratings'

    # save  the state of each rating checkbox and sorting only 
    # if user has selected some checkbox or has aplied some sorting
    if @ordered_by || @checked_ratings
      session[:checked_ratings] = @checked_ratings if @checked_ratings
      session[:ordered_by] = @ordered_by if @ordered_by
    end
    
    # Load save checkboxes rating and sorting only if the user doesn't change the filter
    if !@checked_ratings && session[:checked_ratings] && !@order_by
      @checked_ratings = session[:checked_ratings] unless @checked_ratings
      @ordered_by = session[:ordered_by] unless @ordered_by

      # Next step: redirect in order to preserve RESTful adding nececssary parameters to the HTTP request
      # The page is then loaded twice so we need to make flash survive more than only one single redirect
      flash.keep
      redirect_to movies_path({ratings: @checked_ratings, order_by: @ordered_by})
    end

    # Apply rating filter if neccessary
    if @checked_ratings
      # If we had set an ':order_by' value in hash params[] order de list
      if @ordered_by
        @movies = Movie.where(rating: @checked_ratings.keys).order("#{@ordered_by} asc")
      else
        @movies = Movie.where(rating: @checked_ratings.keys) 
      end
    elsif @ordered_by
      # If we had set an ':order_by' value in hash params[] order de list
      @movies = Movie.order("#{@ordered_by} asc")
      # If not, show all rows of the DB  
    else
        #@movies = Movie.all
        @movies = Movie.order("title asc")
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

  def search_tmdb
    #call model method to find the movie in the data base
    #@movies = Movie.find_in_tmdb(params[:search_terms])
    #hasdwire to simulate failure
    flash[:warning] = "'Movie That Does Not Exists' was not found in TMDb"
    redirect_to movies_path
  end
end
