class InventoryService
  
  def validate_data(params)
    operator = params[:Operator];
    department = params[:department];
    position = params[:position].to_s;
    part = params[:part].to_s;
    part_type = params[:part_type];
    return false if operator.nil? || department.nil? || position.nil? || part.nil? || part_type.nil?

  end
  
  def enter_stock(params)
    
    # if validate_data(params)
      operator = params[:Operator].to_s.downcase;
      
      case operator
      when 'new'
        data = { department: params[:department], position: params[:position], part: params[:part], part_type: params[:part_type], ios_created_id: '', check_time: '', random_check_time: ''}
        Inventory.create!(data)
      when 'update'
        # puts "---------------testing update"
        inventory = Inventory.where(part: params[:part], position: params[:position]).first
        if inventory
          inventory.update!(department: params[:department],  part_type: params[:part_type]) 
        end
      when 'delete'
        inventory = Inventory.where(part: params[:part], position: params[:position]).first
        inventory.destroy if inventory
      else
        
      end
    # else
#       raise '数据异常'
#     end
  end  
  
end
