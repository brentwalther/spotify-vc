module PlaylistHelper
  def track_artists(track)
    track.artists.map { |artist| artist.name.to_s }.join(", ")
  end
end
