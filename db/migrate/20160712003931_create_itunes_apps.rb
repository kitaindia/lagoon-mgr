class CreateItunesApps < ActiveRecord::Migration[5.0]
  def change
    create_table :itunes_apps do |t|
      t.string :name
      t.string :icon_url

      t.timestamps
    end
  end
end
