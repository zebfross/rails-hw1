class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
	@all_ratings = Movie.all_ratings
	shouldRedirect = true
	if params[:ratings]
		ratings = params[:ratings].keys
		session[:ratings] = params[:ratings]
		shouldRedirect = false
	else
		ratings = @all_ratings
	end
	if params[:sort_order]
		session[:sort_order] = params[:sort_order]
		shouldRedirect = false
	end
	if shouldRedirect and (session[:sort_order] or session[:ratings])
		flash.keep
		redirect_to movies_path(:sort_order => session[:sort_order], :ratings => session[:ratings])
	end
    @movies = Movie.all(:order=>params[:sort_order], :conditions=>{:rating=>ratings})
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(params[:movie])
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
