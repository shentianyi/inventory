class CreateInventoryFiles < ActiveRecord::Migration
  def change
    create_table :inventory_files do |t|
      t.string :name
      t.string :path
      t.string :size

      t.timestamps null: false
    end
  end
end
