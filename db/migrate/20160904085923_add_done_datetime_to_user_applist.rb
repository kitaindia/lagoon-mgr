class AddDoneDatetimeToUserApplist < ActiveRecord::Migration[5.0]
  def change
    add_column :user_applists, :review_done_datetime, :datetime
    add_index :user_applists, :review_done_datetime
  end
end
