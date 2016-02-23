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
    @cssClass = "hilite"
    @movies = Movie.all
    if !(params[:sort_by].nil?)
      @movies = Movie.order(params[:sort_by])
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
