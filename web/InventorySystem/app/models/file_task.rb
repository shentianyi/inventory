class FileTask < ActiveRecord::Base
  self.inheritance_column=:_type_disabled

  belongs_to :user
  belongs_to :data_file, class_name: 'InventoryFile'
  belongs_to :err_file, class_name: 'InventoryFile'
  # after_save :create_job

  def create_job
    self.update_attributes(status: FileUploadStatus::EXECUTING)
    FileTaskWorker.perform_async(self.id)
  end

  def self.search(search)
    if search
      where("status LIKE ? or type Like ? ", "%#{search}%", "%#{search}%")
    else
      find(:all)
    end
  end
end
