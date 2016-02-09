class HomeController < ApplicationController

  def index
    return if spotify_user.nil?

    @playlists = spotify_user.playlists
    @playlist_owners = owners_for_playlists(@playlists)
    # @playlists = playlists.map do |playlist|
    #   owner = playlist_owners[playlist.owner.id]
    #   {
    #     id: playlist.id,
    #     name: playlist.name,
    #     owner_id: owner.id,
    #     owner_name: owner.display_name || owner.id
    #   }
    # end
  end

  private
  def owners_for_playlists(playlists)
    playlists.inject({}) do |owners, playlist|
      owners[playlist.owner.id] ||= RSpotify::User.find(playlist.owner.id)
      owners
    end
  end
end
