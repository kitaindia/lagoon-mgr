class AddCollumnToApplist < ActiveRecord::Migration[5.0]
  def change
    add_column :applists, :is_scraped, :boolean, default: false
  end
end
