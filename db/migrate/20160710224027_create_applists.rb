class CreateApplists < ActiveRecord::Migration[5.0]
  def change
    create_table :applists do |t|
      t.string :google_play_uid
      t.string :itunes_uid

      t.timestamps
    end
  end
end
