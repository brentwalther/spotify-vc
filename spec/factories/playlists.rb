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

FactoryGirl.define do
  factory :playlist do
    spotify_id "MyString"
    owner_id "MyString"
    parent_playlist_id "MyString"
  end
end
