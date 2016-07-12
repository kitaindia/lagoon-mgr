class CreateApplists < ActiveRecord::Migration[5.0]
  def change
    create_table :applists do |t|
      t.string :google_play_uid
      t.string :itunes_uid

      t.timestamps
    end

    add_index :applists, :google_play_uid, unique: true
    add_index :applists, :itunes_uid, unique: true
  end
end
