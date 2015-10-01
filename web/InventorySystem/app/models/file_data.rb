require 'base/base_class'
class FileData<CZ::BaseClass
  attr_accessor :type, :oriName, :size, :path, :pathName, :data, :extention, :uuidName, :full_path

  def default
    {:uuidName => SecureRandom.uuid}
  end

  def saveFile
      if @path && !Dir.exists?(@path)
        Dir.mkdir(@path)
      end
      @extention=File.extname(@oriName).downcase
      @pathName=@uuidName+@extention if @pathName.nil?
      @full_path=File.join(@path, @pathName)
      File.open(@full_path,'wb') do |f|
        f.write(@data.read)
      end
      return @pathName
  end

  def self.get_size path
    bytes = File.size(path).to_f
    if bytes<10**3
      return "#{bytes} B"
    elsif bytes<10**6
      return "#{(bytes/10**3).round(2)} KB"
    else
      return "#{(bytes/10**6).round(2)} MB"
    end
  end

  def self.get_type path
    case File.extname(path).downcase
      when '.jpg', '.jpeg', '.gif', '.bmp', '.png'
        return 'image'
      when '.doc', '.docx'
        return 'doc'
      when '.xls', '.xlsx'
        return 'excel'
      when '.ppt', 'pptx'
        return 'ppt'
      when '.pdf'
        return 'pdf'
      when '.zip'
        return 'zip'
      else
        return 'default'
    end
  end

  def self.get_content_type file_name
    case File.extname(file_name).downcase
      when '.jpg', '.jpeg', '.gif', '.bmp', '.png'
        return 'image/jpg'
      when '.png'
        return 'image/png'
      else
        return nil
    end
  end

  alias :save :saveFile
end