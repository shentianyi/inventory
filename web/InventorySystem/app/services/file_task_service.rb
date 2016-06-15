class FileTaskService
  def self.create_file_task params, user
    FileTask.transaction do
      ft=FileTask.new({
                          user_id: user.id,
                          type: params[:type],
                          status: FileUploadStatus::UPLOAD_SUCCESS
                      })

      file=InventoryFile.new()

      File.open('uploadfiles/data/data.json', 'w+') do |f|
        f.write(params[:data])
        file.path = f
      end

      ft.data_file=file

      if ft.save
        true
      else
        false
      end
    end
  end
end
