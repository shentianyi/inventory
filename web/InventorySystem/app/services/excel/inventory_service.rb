module Excel
  class InventoryService
    HEADERS=[
        :sn, :department, :position, :part_nr, :part_unit, :part_type, :operation
    ]

    INVALID_HEADERS=%w(唯一码 部门 库位号 零件号 零件单位 零件类型 operation)

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
                  row[k] = row[k].sub(/\.0/, '')
                end

                operator = row[:operation].to_s.downcase

                case operator
                  when 'new'
                    # data = {sn: row[:sn], department: row[:department], position: row[:position], part_nr: row[:part_nr], ios_created_id: '', check_time: '', random_check_time: ''}
                    data = {sn: row[:sn], department: row[:department], position: row[:position], part_nr: row[:part_nr], part_unit: row[:part_unit], part_type: row[:part_type]}
                    Inventory.create!(data)
                  when 'update'
                    # puts "---------------testing update"
                    inventory = Inventory.where(sn: row[:sn]).first
                    if inventory
                      inventory.update!(department: row[:department], position: row[:position], part_nr: row[:part_nr], part_unit: row[:part_unit], part_type: row[:part_type])
                    end
                  when 'delete'
                    # puts "---------------testing delte"
                    inventory = Inventory.where(sn: row[:sn]).first
                    inventory.destroy if inventory
                  else

                end

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
      tmp_file = full_tmp_path(file.oriName)
      msg = Message.new(result: true)
      book = Roo::Excelx.new file.full_path
      book.default_sheet = book.sheets.first

      p = Axlsx::Package.new
      p.workbook.add_worksheet(:name => "Basic Worksheet") do |sheet|
        sheet.add_row INVALID_HEADERS+['Error Msg']
        #validate file
        2.upto(book.last_row) do |line|

          row = {}
          HEADERS.each_with_index do |k, i|
            row[k] = book.cell(line, i+1).to_s.strip
            row[k] = row[k].sub(/\.0/, '')
          end

          mssg = validate_import_row(row, line)
          if mssg.result
            sheet.add_row row.values
          else
            if msg.result
              msg.result = false
              msg.content = "下载错误文件<a href='/files/#{Base64.urlsafe_encode64(tmp_file)}'>#{::File.basename(tmp_file)}</a>"
            end
            sheet.add_row row.values<<mssg.content
          end
        end
      end
      p.use_shared_strings = true
      p.serialize(tmp_file)
      msg
    end

    def self.validate_import_row(row, line)
      msg = Message.new(contents: [])

      if row[:sn].blank?
        msg.contents << "唯一码不能为空!"
      end

      if row[:department].blank?
        msg.contents << "部门不能为空!"
      end

      if row[:position].blank?
        msg.contents << "库位不能为空!"
      end

      if row[:part_nr].blank?
        msg.contents << "零件号不能为空!"
      end

      if row[:part_unit].blank?
        msg.contents << "零件单位不能为空!"
      end

      if row[:part_type].blank?
        msg.contents << "零件类型不能为空!"
      end

      if row[:operation].blank?
        msg.contents << "操作不能为空!"
      end

      operator = row[:operation].downcase.to_s

      i = Inventory.where(sn: row[:sn]).first
      case operator
        when 'new'
          if i.present?
            msg.contents << "此唯一码 已经被占用!"
          elsif ii=Inventory.where(part_nr: row[:part_nr], position: row[:position], department: row[:department]).first
            if ii.present?
              msg.contents << "此部门库位已存在"
            end
          end
        when 'update'
          if !i.present?
            msg.contents << "无此唯一码!"
          end
        when 'delete'
          if !i.present?
            msg.contents << "无此唯一码!"
          end
      end

      unless msg.result=(msg.contents.size==0)
        msg.content=msg.contents.join('/')
      end
      msg
    end


  end
end

