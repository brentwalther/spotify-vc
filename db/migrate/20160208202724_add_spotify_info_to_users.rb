class AddSpotifyInfoToUsers < ActiveRecord::Migration
  def up
    add_column :users, :spotify_info, :text
  end

  def down
    remove_column :users, :spotify_info
  end
end
