class PlaylistController < ApplicationController

  def show
    db_playlist = Playlist.find_or_create_by(spotify_id: playlist_id, owner_id: owner_id)
    @snapshots = db_playlist.snapshots
    @playlist = RSpotify::Playlist.find(owner_id, playlist_id)
    @tracks = tracks_for_playlist(@playlist)
  end

  def compare
    @result = search_spotify # collect search result if search parameters exist
    @playlist = RSpotify::Playlist.find(owner_id, playlist_id)
    @tracklist_names = [ @playlist.name ]
    @tracklists = [ tracks_for_playlist(@playlist) ]

    if @result.is_a?(RSpotify::Album)
      @tracklist_names.push(@result.name)
      @tracklists.push(@result.tracks)
    elsif @result.is_a?(RSpotify::Playlist)
      @tracklist_names.push(@result.name)
      @tracklists.push(tracks_for_playlist(@result))
    end

    @tracklists, @diff_results = diff_tracklists(@tracklists)
  end

  private
  def playlist_id
    params.require(:id).to_s
  end

  def owner_id
    params.require(:owner_id).to_s
  end

  def diff_tracklists(tracklists)
    return [ tracklists, [ nil ] ] if tracklists.size < 2

    first_list = tracklists.first.map(&:id).sort
    diff_results = tracklists.last.map { |track| first_list.include?(track.id) }

    [ tracklists, [ nil, diff_results ] ]
  end
end
