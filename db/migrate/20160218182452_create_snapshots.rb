class CreateSnapshots < ActiveRecord::Migration
  def change
    create_table :snapshots do |t|
      t.references :playlist, index: true
      t.text :track_list

      t.timestamps
    end
  end
end
