class InventoryService
  
  def validate_data(params)
    operator = params[:operation];
    department = params[:department];
    position = params[:position].to_s;
    part = params[:part].to_s;
    part_type = params[:part_type];
    return false if operator.nil? || department.nil? || position.nil? || part.nil? || part_type.nil?

  end
  
  def enter_stock(params)
    departmentValue = params[:department]
    if params[:department].include? ".0"
      departmentValue = params[:department].to_i
    end
    
    positionValue = params[:position]
    if params[:position].include? ".0"
      positionValue = params[:position].to_i
    end
    
    partValue = params[:part]
    if params[:part].include? ".0"
      partValue = params[:part].to_i
    end
    # puts "testing the part value #{partValue}"
    partTypeValue = params[:part_type]
    if params[:part_type].include? ".0"
      partTypeValue = params[:part_type].to_i
    end
    # if validate_data(params)
    operator = params[:operation].to_s.downcase;
      
    case operator
    when 'new'
        
      data = { department: departmentValue, position: positionValue, part: partValue, part_type: partTypeValue, ios_created_id: '', check_time: '', random_check_time: ''}
      Inventory.create!(data)
    when 'update'
      # puts "---------------testing update"
      inventory = Inventory.where(partValue, position: positionValue).first
      if inventory
        inventory.update!(department: departmentValue,  part_type: partTypeValue) 
      end
    when 'delete'
      # puts "---------------testing delte"
      inventory = Inventory.where(part: partValue, position: positionValue).first
      inventory.destroy if inventory
    else
        
    end
    # else
    #       raise '数据异常'
    #     end
  end  
  
end
