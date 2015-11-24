class AddPartUnitAndPartTypeToInventories < ActiveRecord::Migration
  def change
    add_column :inventories, :part_unit, :string
    add_column :inventories, :part_type, :string
  end
end
