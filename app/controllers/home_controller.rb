class HomeController < ApplicationController

  def index
    return if spotify_user.nil?

    @playlists = spotify_user.playlists.map { |p| p.owner.complete!; p }
    @playlist_snapshots = @playlists.map { |p| Snapshot.joins(:playlist).where("playlists.spotify_id" => p.id).first }
  end
end
