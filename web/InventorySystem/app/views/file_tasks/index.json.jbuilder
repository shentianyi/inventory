json.array!(@file_tasks) do |file_task|
  json.extract! file_task, :id, :user_id, :data_file_id, :err_file_id, :status, :remark
  json.url file_task_url(file_task, format: :json)
end
