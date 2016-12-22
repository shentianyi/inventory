class AddWireNrAndProcessNrToInventories < ActiveRecord::Migration
  def change
    add_column :inventories, :wire_nr, :string
    add_column :inventories, :process_nr, :string
  end
end
