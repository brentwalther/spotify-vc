class Playlist < ActiveRecord::Base

  def forked?
    parent_playlist_id.present?
  end
end
