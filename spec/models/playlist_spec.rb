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

require 'rails_helper'

RSpec.describe Playlist, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
