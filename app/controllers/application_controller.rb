class ApplicationController < ActionController::Base

  ALLOWED_SEARCH_METHODS = %w( user album artist ) # values for which we can constantize into RSpotify classes

  def authenticate_with_spotify
    RSpotify.authenticate(ENV["SPOTIFY_CLIENT_ID"], ENV["SPOTIFY_CLIENT_SECRET"])
  end

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_filter :authenticate_with_spotify

  private
  def spotify_user
    return nil unless current_user
    RSpotify::User.new(current_user.spotify_info)
  end

  def search_spotify
    return unless params.include?('search-string') &&
      params.include?('search-by') &&
      ALLOWED_SEARCH_METHODS.include?(params['search-by'])

    search_by = params.require('search-by')
    query = params.require('search-string')

    klass = "RSpotify::#{search_by.capitalize}".constantize

    @results = if search_by.eql?('user')
      klass.find(query)
    else
      @results = klass.search(query)
    end

  end
end
