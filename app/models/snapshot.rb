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

class Snapshot < ActiveRecord::Base
  belongs_to :playlist
end
