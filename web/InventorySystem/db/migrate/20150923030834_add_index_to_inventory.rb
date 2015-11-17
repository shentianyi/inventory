class AddIndexToInventory < ActiveRecord::Migration
  def change
    
    add_index :inventories, :position
    
  end
end
