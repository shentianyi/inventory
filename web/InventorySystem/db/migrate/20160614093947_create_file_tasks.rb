class CreateFileTasks < ActiveRecord::Migration
  def change
    create_table :file_tasks do |t|
      t.references :user, index: true, foreign_key: true
      t.integer :data_file_id
      t.integer :err_file_id
      t.integer :status
      t.string :remark
      t.integer :type

      t.timestamps null: false
    end
  end
end
