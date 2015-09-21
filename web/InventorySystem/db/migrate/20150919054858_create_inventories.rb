class CreateInventories < ActiveRecord::Migration
  def change
    create_table :inventories do |t|
      t.string :department, :null=> false
      t.string :position, :null=> false
      t.string :part, :null=> false
      t.string :part_type, :null=> false
      t.float :check_qty
      t.string :check_user
      t.datetime :check_time
      t.float :random_check_qty
      t.string :random_check_user
      t.datetime :random_check_time
      t.boolean :is_random_check, :default => false
      t.string :ios_created_id

      t.timestamps null: false
    end
  end
end
