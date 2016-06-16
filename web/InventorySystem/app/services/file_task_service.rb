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
        FileTaskWorker.perform_async(ft.id)
        true
      else
        false
      end
    end
  end

  def self.update_check_data data, type
    msg=Message.new(contents: [])
    Inventory.transaction do
      unless data.blank?
        case type
          when FileUploadType::OVERALL
            data.each do |i|
              if i['id'].blank? && Inventory.find_by_sn(i['sn']).blank?
                inventory = Inventory.new(sn: i['sn'],
                                          department: i['department'],
                                          position: i['position'],
                                          part_nr: i['part_nr'],
                                          part_unit: i['part_unit'],
                                          part_type: i['part_type'],
                                          wire_nr: i['wire_nr'],
                                          process_nr: i['process_nr'],
                                          check_qty: i['check_qty'],
                                          check_user: i['check_user'],
                                          check_time: i['check_time'],
                                          ios_created_id: i['ios_created_id'])
                unless inventory.save!
                  msg.contents<<(i.to_s + "CREATE NEW DATA FAILED")
                end
              else
                inventory = i['id'].blank? ? Inventory.find_by_sn(i['sn']) : Inventory.find_by_id(i['id'])
                if inventory.present?
                  if inventory.update!(check_qty: i['check_qty'], check_user: i['check_user'], check_time: i['check_time'])
                  else
                    msg.contents<<(i.to_s + "UPDATE NEW DATA FAILED")
                  end
                else
                  msg.contents<<(i.to_s + "CAN NOT FIND THIS DATA")
                end
              end
            end


          when FileUploadType::SPOTCHECK
            data.each do |i|
              if i['id'].blank?
                msg.contents<<(i.to_s + "CAN NOT FIND THIS DATA'S [ID]")
              else
                inventory = Inventory.find_by_id(i['id'])
                if inventory.present?
                  if inventory.update!(random_check_qty: i['random_check_qty'],
                                       random_check_user: i['random_check_user'],
                                       random_check_time: i['random_check_time'])
                  else
                    msg.contents<<(i.to_s + "UPDATE NEW DATA FAILED")
                  end
                else
                  msg.contents<<(i.to_s + "CAN NOT FIND THIS DATA")
                end
              end


            end
        end

        unless msg.result=(msg.contents.size==0)
          msg.content=msg.contents.join('/')
        end
      end
    end

    msg
  end
end
