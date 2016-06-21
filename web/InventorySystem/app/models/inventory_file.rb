class InventoryFile < ActiveRecord::Base
  mount_uploader :path, InventoryFileUploader

  def self.url(id, http_host)
    if file=InventoryFile.find_by_id(id)
      http_host+file.path.url
    end
  end
end
