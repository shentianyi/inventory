module Excel
class ExcelService
  HEADERS=[
    :department, :position, :part, :part_type, :operator
  ]
  
  def self.import(file)
    msg = Message.new
    book = Roo::Excelx.new file.full_path
    book.default_sheet = book.sheets.first
    
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
    msg
  end
end
end

