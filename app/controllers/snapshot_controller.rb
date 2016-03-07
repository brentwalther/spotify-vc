class SnapshotController < ApplicationController

  def create
    @playlist = RSpotify::Playlist.find(owner_id, playlist_id)
    @tracks = tracks_for_playlist(@playlist)
    db_playlist = Playlist.find_by(spotify_id: playlist_id, owner_id: owner_id)
    db_playlist.snapshots.create(track_list: @tracks.map(&:id).join(", "))

    redirect_to playlist_show_path(owner_id: owner_id, id: playlist_id)
  end

  private
  def playlist_id
    params.require(:id).to_s
  end

  def owner_id
    params.require(:owner_id).to_s
  end
end
