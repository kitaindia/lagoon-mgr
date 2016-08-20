class AddCollumnToUser < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :is_reviewer, :boolean, default: false
  end
end
