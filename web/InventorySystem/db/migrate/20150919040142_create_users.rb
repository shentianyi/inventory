class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :nr, :unique => true
      t.string :name

      t.timestamps null: false
    end
  end
end
