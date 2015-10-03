class InventoryService
  
  def validate_data(params)
    operator = params[:operator];
    department = params[:department];
    position = params[:position].to_s;
    part = params[:part].to_s;
    part_type = params[:part_type];
    return false if operator.nil? || department.nil? || position.nil? || part.nil? || part_type.nil?
    
    prt = operator.to_s
    case prt
    when 'new'
      puts "---------------testing #{position}"
      raise 'uniqueId already exists!' if position.present? and Inventory.find_by_position(position)
      raise 'uniqueId already exists!' if part.present? and Inventory.find_by_part(part)
    when 'update'
      inventory = Inventory.where(part: part, position: position).first 
    when 'delete'
      inventory = Inventory.where(part: part, position: position).first
    else
      return false
    end
    return true
  end
  
  def enter_stock(params)
    puts '----------------------ss'
    if validate_data(params)
      operator = params[:operator].to_s;
      case operator
      when 'new'
        data = { department: params[:department], position: params[:position], part: params[:part], part_type: params[:part_type], ios_created_id: '', check_time: DateTime.now, random_check_time: DateTime.now}
        Inventory.create!(data)
      when 'update'
        # puts "---------------testing update"
        inventory = Inventory.where(part: params[:part], position: params[:position]).first
        if inventory
          inventory.update!(department: params[:department],  part_type: params[:part_type]) 
        end
      else
        inventory = Inventory.where(part: params[:part], position: params[:position]).first
        inventory.destroy if inventory
      end
    else
      raise 'data is unvalidate'
    end
  end  
  
end