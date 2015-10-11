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
      
      desc "get checkdata page size"
      get :get_total do
        inventories = Inventory.check)
        if inventories.present?
          {result:1, content: inventories.total_pages}
        else
          {result:0, content: '当前无数据'}
        end
      end
      
      desc "downlaod check_data"
      params do
        requires :page, type: String
      end
      get :download_check_data do
        inventories = Inventory.check.paginate(page: params[:page])
        if inventories.present?
          {result:1, content: inventories}
        else
          {result:0, content: '当前无数据'}
        end
      end
      
      desc "upload check_data"
      params do
        requires :id, type: Integer
        requires :department, type: String
        requires :position, type: String
        requires :part, type: String
        requires :part_type, type: String
        requires :check_qty, type: String
        requires :check_user, type: String
        requires :check_time, type: String
        requires :ios_created_id, type: String
      end
      post :upload_check_data do
        if params[:id].blank?
          inventory = Inventory.new(department: params[:department], position: params[:position], part: params[:part], part_type: params[:part_type], check_qty: params[:check_qty], check_user: params[:check_user], check_time: params[:check_time], ios_created_id: params[:ios_created_id])
          if inventory.save!
            {result:1, content: inventory}
          else
            {result:0, content: '新建数据失败'}
          end
        else
          inventory = Inventory.find(params[:id])
          if inventory.present?
            if inventory.update!(check_qty: params[:check_qty], check_user: params[:check_user], check_time: params[:check_time])
              {result:1, content: inventory}
            else
              {result:0, content: '更新数据失败'}
            end
          end
        end
      end
    end
  end
end