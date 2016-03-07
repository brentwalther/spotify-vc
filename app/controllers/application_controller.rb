class ApplicationController < ActionController::Base

  ALLOWED_SEARCH_METHODS = %w( album artist album_id artist_id user_id playlist_id ) # values for which we can constantize into RSpotify classes

  TRACKS_PER_PAGE = 100 # the number of tracks per page in a spotify track request

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

  def tracks_for_playlist(playlist)
    total_pages = (playlist.total.to_f / TRACKS_PER_PAGE).ceil
    (0..total_pages).inject([]) do |track_list, page_number|
      offset = TRACKS_PER_PAGE * page_number
      limit = TRACKS_PER_PAGE
      track_list = track_list + playlist.tracks(offset: offset, limit: limit)
    end
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
        # Use the classes #find method to obtain the object for the particular ID. In the case of
        # playlists, we expect the playlist owner's ID to be passed in as well.
        result = if search_by.eql?('playlist')
          klass.find(params.require('other_owner_id'), query)
        else
          klass.find(query)
        end

        # After the object is found, we need to end up returning the list of data that is displayed
        case search_by
        when 'album', 'playlist'
          result
        when 'user'
          result.playlists.map { |p| p.owner.complete!; p }
        when 'artist'
          result.albums(limit: 50, market: 'US')
        end
      rescue RestClient::ResourceNotFound, RestClient::BadRequest
        nil
      end
    else
      klass.search(query, market: 'US')
    end
  end
end
