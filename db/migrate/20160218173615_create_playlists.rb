class CreatePlaylists < ActiveRecord::Migration
  def change
    create_table :playlists do |t|
      t.string :spotify_id
      t.string :owner_id
      t.string :parent_playlist_id

      t.timestamps
    end
  end
end
