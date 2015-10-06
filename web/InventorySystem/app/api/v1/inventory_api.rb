module V1
  class InventoryApi < Grape::API
    namespace :inventory do
      format :json
      
      desc "List all Inventories"
      get do
        inventories = Inventory.all
        {result: 1, content: inventories}
      end
      
      desc "Query"
      params do
        requires :position, type: String
      end
      get :query do
        inventories = Inventory.check_for_search(params[:position])
        if inventories.present?
          if inventories.count > 1
            {result: 0, content: "此库位包含多个零件，请手动录入"}
          else
            {result: 1, content: inventories}
          end
        else
          {result: 0, content: "不存在库位信息，请手动录入"} 
        end
      end
      
      desc "check"
      params do
        requires :position, type: String
        requires :check_qty, type: String
        requires :check_user, type: String
        requires :check_time, type: String
      end
      post :check_data do
        puts "======testing"
        inventory = Inventory.check_for_search(params[:position])      
        if inventory.present?
          if inventory.count == 1
            if inventory[0].update!(check_qty: params[:check_qty],  check_user: params[:check_user], check_time: params[:check_time])
              {result: 1, content: "操作成功" }
            else
              {result: 0, content: "操作失败" }
            end
          else
            {result: 0, content: "此库位包含多个零件，请手动录入"}
          end
        else
          {result: 0, content: "不存在库位信息，请手动录入"}   
        end
      end
      
      
      
    end
  end
end