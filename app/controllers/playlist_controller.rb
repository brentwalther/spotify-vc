class PlaylistController < ApplicationController

  before_filter :search_spotify

  TRACKS_PER_PAGE = 100

  def show
    @playlist = RSpotify::Playlist.find(owner_id, playlist_id)
    @tracks = tracks_for_playlist(@playlist)
  end

  def compare
    @other_playlist, @other_tracks = session[:comparison_playlist]
    @playlist = RSpotify::Playlist.find(owner_id, playlist_id)
    @tracks = tracks_for_playlist(@playlist)
  end

  private
  def playlist_id
    params.require(:id).to_s
  end

  def owner_id
    params.require(:owner_id).to_s
  end

  def tracks_for_playlist(playlist)
    total_pages = (playlist.total.to_f / TRACKS_PER_PAGE).ceil
    (0..total_pages).inject([]) do |track_list, page_number|
      offset = TRACKS_PER_PAGE * page_number
      limit = TRACKS_PER_PAGE
      track_list = track_list + playlist.tracks(offset: offset, limit: limit)
    end
  end
end
