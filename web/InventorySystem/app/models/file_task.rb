class FileTask < ActiveRecord::Base
  self.inheritance_column=:_type_disabled

  belongs_to :user
  belongs_to :data_file, class_name: 'InventoryFile'
  belongs_to :err_file, class_name: 'InventoryFile'
end
