class HomeController < ApplicationController

  def index
    return if spotify_user.nil?

    @playlists = spotify_user.playlists.map { |p| p.owner.complete!; p }
  end
end
