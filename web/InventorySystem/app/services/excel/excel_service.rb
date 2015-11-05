module Excel
class ExcelService
  HEADERS=[
    :department, :position, :part, :part_type, :Operator
  ]
  
  def self.full_tmp_path(file_name)
    File.join('uploadfiles', Time.now.strftime('%Y%m%d%H%M%S%L')+'-'+file_name)
  end
  
  def self.import(file)
    msg = Message.new
    book = Roo::Excelx.new file.full_path
    book.default_sheet = book.sheets.first
    
    validate_msg = validate_import(file)
    if validate_msg.result
      begin
        Inventory.transaction do
          puts "====== test here #{book.last_row}========"
          if book.last_row >= 2
            2.upto(book.last_row) do |line| 
              row = {}  
              HEADERS.each_with_index do |k, i|
                row[k] = book.cell(line, i+1).to_s.strip
              end
              InventoryService.new.enter_stock(row)
            end
            msg.result = true
            msg.content = "导入数据成功"
          else
            msg.result = false
            msg.content = "导入数据不能为空"
          end
        end
      
      rescue => e
        puts "====== test ========#{e.message}"
        puts e.backtrace
        msg.result = false
        msg.content = e.message
      end
    else
      msg.result = false
      msg.content = validate_msg.content
    end

    msg
  end

  
  def self.validate_import file
    puts "testing hello #{file.oriName}"
    tmp_file                       = full_tmp_path(file.oriName)
    
    msg                            = Message.new(result: true)
    book                           = Roo::Excelx.new file.full_path
    book.default_sheet             = book.sheets.first

    p                              = Axlsx::Package.new
    p.workbook.add_worksheet(:name => "Basic Worksheet") do |sheet|
      sheet.add_row HEADERS+['Error Msg']
      #validate file
      2.upto(book.last_row) do |line|
        
        row                        = {}
        HEADERS.each_with_index do |k, i|
          row[k]                   = book.cell(line, i+1).to_s.strip
          # row[k]                   = row[k].sub(/\.0/, '') if k== :partNr || k== :packageId
        end

        mssg                       = validate_import_row(row, line)
        if mssg.result
          sheet.add_row row.values
        else
          if msg.result
            msg.result             = false
            msg.content            = "下载错误文件<a href='/files/#{Base64.urlsafe_encode64(tmp_file)}'>#{::File.basename(tmp_file)}</a>"
          end
          sheet.add_row row.values<<mssg.content
        end
      end
    end
    p.use_shared_strings           = true
    p.serialize(tmp_file)
    msg
  end
  
  def self.validate_import_row(row, line)
    msg = Message.new(contents: [])
    
    if row[:department].nil?
      msg.contents << "部门:#{row[:department]} 不为空!"
    end

    if row[:position].nil?
      msg.contents << "库位:#{row[:position]} 不为空!"
    end

    if row[:part].nil?
      msg.contents << "零件号: #{row[:part]} 不为空!"
    end

    if row[:part_type].nil?
      msg.contents << "零件类型: #{row[:part_type]} 不为空!"
    end

    if row[:Operator].nil?
      msg.contents << "操作: #{row[:operator]} 不为空!"
    end
    
    operator = row[:Operator].to_s
    puts "#{row[:part].to_i}, #{row[:position].to_s}"
    i = Inventory.where(part: row[:part].to_s).where(position: row[:position].to_s)
    case operator
    when 'new'
      if i.present?
        msg.contents << "库位 零件 已经被占用!"
      end
    when 'update'
      if !i.present?
        msg.contents << "无此库位 零件!"
      end
    when 'delete'
      if !i.present?
        msg.contents << "无此库位 零件!"
      end
    end

    unless msg.result=(msg.contents.size==0)
      msg.content=msg.contents.join('/')
    end
    msg
  end

  

end
end

