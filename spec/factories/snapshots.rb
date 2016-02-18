# == Schema Information
#
# Table name: snapshots
#
#  id          :integer          not null, primary key
#  playlist_id :integer
#  track_list  :text
#  created_at  :datetime
#  updated_at  :datetime
#
# Indexes
#
#  index_snapshots_on_playlist_id  (playlist_id)
#

FactoryGirl.define do
  factory :snapshot do
    playlist nil
    track_list "MyText"
  end
end
