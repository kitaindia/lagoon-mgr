class CreateApplists < ActiveRecord::Migration[5.0]
  def change
    create_table :applists do |t|
      t.string :google_play_url
      t.string :itunes_url

      t.timestamps
    end

    add_index :applists, :google_play_url
    add_index :applists, :itunes_url
  end
end
