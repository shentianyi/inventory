FileTask.transaction do
    FileTask.where(status: 100).each do |ft|
FileTaskWorker.perform_async(ft.id)
    end

end
