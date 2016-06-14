class InventoryFile < ActiveRecord::Base
  mount_uploader :path, InventoryFileUploader
end
