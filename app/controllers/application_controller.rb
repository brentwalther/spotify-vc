class ApplicationController < ActionController::Base

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
end
