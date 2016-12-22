class ChangeInventoriesColumns < ActiveRecord::Migration
  def change
   remove_column :inventories, :part_type
   rename_column :inventories,:part, :part_nr
  end
end
