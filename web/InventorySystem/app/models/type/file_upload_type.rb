class FileUploadType
  OVERALL=100
  SPOTCHECK=200

  def self.display(type)
    case type
      when OVERALL
        '全盘'
      when SPOTCHECK
        '抽盘'
    end
  end

end