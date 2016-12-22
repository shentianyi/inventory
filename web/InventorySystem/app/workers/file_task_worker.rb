class FileTaskWorker
  include Sidekiq::Worker

  sidekiq_options :queue => :file_task, :retry => true

  def perform(id)
    if ft=FileTask.find_by_id(id)
      unless ft.data_file.blank?
        msg=FileTaskService.update_check_data(JSON.parse(File.read("public" + ft.data_file.path.url)), ft.type)
        if msg.result
          ft.update_attributes(status: FileUploadStatus::ENDING)
        else
          ft.update_attributes(status: FileUploadStatus::ERROR)

          file=InventoryFile.new()
          File.open('uploadfiles/data/data.json', 'w+') do |f|
            f.write(msg.content)
            file.path = f
          end
          ft.err_file=file
          ft.save
        end
      end
    end
  end
end