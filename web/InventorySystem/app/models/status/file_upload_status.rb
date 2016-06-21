class FileUploadStatus
  UPLOAD_SUCCESS=100
  EXECUTING=200
  ENDING=300
  ERROR=400

  def self.display(status)
    case status
      when UPLOAD_SUCCESS
        '上传成功'
      when EXECUTING
        '执行中'
      when ENDING
        '结束'
      when ERROR
        '出错'
    end
  end

end