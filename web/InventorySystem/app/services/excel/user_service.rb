module Excel
  class UserService
    HEADERS=[
        :nr, :name, :role,:id_span, :operation
    ]

    INVALID_HEADERS=%w(员工号 姓名 权限 任务ID operation)


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
          User.transaction do
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
                    User.create!(nr: row[:nr], name: row[:name], role: row[:role],id_span:row[:id_span])
                  when 'update'
                    if user= User.where(nr: row[:nr]).first
                      user.update!(name: row[:name], role: row[:role],id_span:row[:id_span])
                    end
                  when 'delete'
                    user = User.where(nr: row[:nr]).first
                    user.destroy if user
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
            sheet.add_row row.values,types:[:string]
          else
            if msg.result
              msg.result = false
              msg.content = "下载错误文件<a href='/files/#{Base64.urlsafe_encode64(tmp_file)}'>#{::File.basename(tmp_file)}</a>"
            end
            sheet.add_row row.values<<mssg.content,types:[:string]
          end
        end
      end
      p.use_shared_strings = true
      p.serialize(tmp_file)
      msg
    end

    def self.validate_import_row(row, line)
      msg = Message.new(contents: [])

      if row[:nr].blank?
        msg.contents << "员工号不能为空!"
      end

      if row[:name].blank?
        msg.contents << "姓名不能为空!"
      end

      if row[:role].blank?
        msg.contents << "权限不能为空!"
      end

      if row[:role].present?
        msg.contents << "权限: #{row[:role]} 不存在!" unless User.validate_role(row[:role])
      end
      
      if row[:operation].blank?
        msg.contents << "操作不能为空!"
      end

      operator = row[:operation].downcase.to_s

      i = User.where(nr: row[:nr]).first
      case operator
        when 'new'
          if i.present?
            msg.contents << "员工号已存在!"
          end
        when 'update'
          if !i.present?
            msg.contents << "员工号不存在，不可以更新!"
          end
        when 'delete'
          if !i.present?
            msg.contents << "员工号不存在，不可以删除!"
          end
      end

      unless msg.result=(msg.contents.size==0)
        msg.content=msg.contents.join('/')
      end
      msg
    end


  end
end

