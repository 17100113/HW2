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
    @cssClass = "hilite"
    @movies = Movie.all
    @selectedRatings = @all_ratings
    if (!params[:ratings].nil? && session[:ratings].nil?)
        session[:ratings] = params[:ratings]
    end
    if (params[:ratings].nil? && !session[:ratings].nil?)
        params[:ratings] = session[:ratings]
    end
    
    if (!params[:ratings].nil? && !session[:ratings].nil?)
        session[:ratings] = params[:ratings]
    end
    
    if (!params[:ratings].nil?) 
      
      arr = []
      params[:ratings].each {|key, value| arr.push(key) }
      
      @movies = Movie.where(rating: arr)
      @selectedRatings = arr
    end
    
    if (!params[:sort_by].nil? && session[:sort_by].nil?)
        session[:sort_by] = params[:sort_by]
    end
    if (params[:sort_by].nil? && !session[:sort_by].nil?)
        params[:sort_by] = session[:sort_by]
    end
    
    if !(params[:sort_by].nil?)
      @movies = Movie.order(params[:sort_by]).where(rating: @selectedRatings)
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

  def updateMovie
    
  end
  
  def deleteByRating
    if (params.has_key?(:movie))
      @movies = Movie.where(rating: params[:movie][:rating])
      @movies.destroy_all
      flash[:notice] = "Deleted!"
      redirect_to deleteByRating_movies_path
    end
  end
  
  def deleteByTitle
    if (params.has_key?(:movie))
      @movies = Movie.where(title: params[:movie][:title])
      @movies.destroy_all
      flash[:notice] = "Deleted!"
      redirect_to deleteByTitle_movies_path
    end
  end

  def updateMovieFunc

    if (params[:movie][:title] && params[:movie][:rating])
      @movie = Movie.find_by_title(params[:movie][:title]) 
      if (@movie.nil?)
        flash[:notice] = "Movie doesn't exist, soz"
      else
        @movie.update_attributes!(movie_params)
        flash[:notice] = "#{@movie.title} was successfully updated."
      end
    else 
      flash[:notice] = "Fill in all the fields!"
    end
    redirect_to updateMovie_movies_path
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
