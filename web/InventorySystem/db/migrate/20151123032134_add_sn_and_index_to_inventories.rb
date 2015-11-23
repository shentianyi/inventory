class AddSnAndIndexToInventories < ActiveRecord::Migration
  def change
    add_column :inventories, :sn, :integer
    add_index :inventories, :part_nr
  end
end
