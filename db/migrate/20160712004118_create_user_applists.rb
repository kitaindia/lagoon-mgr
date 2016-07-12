class CreateUserApplists < ActiveRecord::Migration[5.0]
  def change
    create_table :user_applists do |t|
      t.integer :user_id
      t.integer :applist_id
      t.boolean :is_done

      t.timestamps
    end
  end
end
