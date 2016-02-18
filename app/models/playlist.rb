# == Schema Information
#
# Table name: playlists
#
#  id                 :integer          not null, primary key
#  spotify_id         :string(255)
#  owner_id           :string(255)
#  parent_playlist_id :string(255)
#  created_at         :datetime
#  updated_at         :datetime
#

class Playlist < ActiveRecord::Base

  def forked?
    parent_playlist_id.present?
  end
end
