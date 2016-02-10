class ApplicationController < ActionController::Base

  ALLOWED_SEARCH_METHODS = %w( album artist album_id artist_id user_id ) # values for which we can constantize into RSpotify classes

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
    return unless params.include?('search_string') &&
      params.include?('search_by') &&
      ALLOWED_SEARCH_METHODS.include?(params['search_by'])

    search_by = params.require('search_by')
    query = params.require('search_string')

    if (is_search_by_id = search_by.match(/([a-z]+)_id/))
      search_by = is_search_by_id[1]
    end

    klass = "RSpotify::#{search_by.capitalize}".constantize

    if is_search_by_id
      begin
        result = klass.find(query)
        case search_by
        when "user"
          { complete: false, data: result.playlists.map { |p| p.owner.complete!; p } }
        when "album"
          { complete: true, data: result }
        when "artist"
          { complete: false, data: result.albums }
        end
      rescue RestClient::ResourceNotFound, RestClient::BadRequest
        nil
      end
    else
      { complete: false, data: klass.search(query) }
    end

  end
end
