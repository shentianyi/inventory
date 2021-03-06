module V1
  class InventoryApi < Grape::API
    namespace :inventory do
      format :json

      desc "testing sample"
      get :sample do
        Inventory.create_random_data
        {result: 1}
      end

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
            if inventory[0].update!(check_qty: params[:check_qty], check_user: params[:check_user], check_time: params[:check_time])
              {result: 1, content: "操作成功"}
            else
              {result: 0, content: "操作失败"}
            end
          else
            {result: 0, content: "此库位包含多个零件，请手动录入"}
          end
        else
          {result: 0, content: "不存在库位信息，请手动录入"}
        end
      end

      desc "random_check"
      params do
        requires :position, type: String
        requires :random_check_qty, type: String
        requires :random_check_user, type: String
        requires :random_check_time, type: String
      end
      post :random_check_data do
        puts "======testing"
        inventory = Inventory.check_for_search(params[:position])
        if inventory.present?
          if inventory.count == 1
            if inventory[0].update!(random_check_qty: params[:random_check_qty], random_check_user: params[:random_check_user], random_check_time: params[:random_check_time], is_random_check: true)
              {result: 1, content: "操作成功"}
            else
              {result: 0, content: "操作失败"}
            end
          else
            {result: 0, content: "此库位包含多个零件，请手动录入"}
          end
        else
          {result: 0, content: "不存在库位信息，请手动录入"}
        end
      end

      desc 'inventory total'
      get :total do
        # inventories = Inventory.check.paginate(page: '1', per_page: params[:per_page
        {result: 1, content: Inventory.count}
      end

      desc "downlaod check_data"
      params do
        optional :page, type: Integer
        optional :per_page, type: Integer
        optional :user, type: Integer
      end
      get :download_check_data do
        # inventories = Inventory.check.paginate(page: params[:page], per_page: params[:per_page])
        if params[:page].present? && params[:per_page].present?
          inventories = Inventory.offset(params[:page]*params[:per_page]).limit(params[:per_page])
        elsif params[:user].present?
          inventories = Inventory.where("check_user = #{params[:user]}")
        else
          inventories = Inventory.all
        end
        if inventories.present?
          # {result:1, content: inventories}
          present :result, 1
          present :content, inventories
        else
          {result: 0, content: '当前无数据'}
        end
      end

      desc "upload check_data"
      params do
        requires :id, type: Integer
        requires :sn, type: Integer
        requires :department, type: String
        requires :position, type: String
        requires :part_nr, type: String
        requires :part_unit, type: String
        requires :part_type, type: String
        requires :wire_nr, type: String
        requires :process_nr, type: String
        requires :check_qty, type: String
        requires :check_user, type: String
        requires :check_time, type: String
        requires :ios_created_id, type: String
      end
      post :upload_check_data do
        if params[:id].blank? && Inventory.find_by_sn(params[:sn]).blank?
          inventory = Inventory.new(sn: params[:sn],
                                    department: params[:department],
                                    position: params[:position],
                                    part_nr: params[:part_nr],
                                    part_unit: params[:part_unit],
                                    part_type: params[:part_type],
                                    wire_nr:params[:wire_nr],
                                    process_nr:params[:process_nr],
                                    check_qty: params[:check_qty],
                                    check_user: params[:check_user],
                                    check_time: params[:check_time],
                                    ios_created_id: params[:ios_created_id])
          if inventory.save!
            {result: 1, content: inventory}
          else
            {result: 0, content: '新建数据失败'}
          end
        else
          inventory = params[:id].blank? ? Inventory.find_by_sn(params[:sn]) : Inventory.find_by_id(params[:id])
          if inventory.present?
            if inventory.update!(check_qty: params[:check_qty], check_user: params[:check_user], check_time: params[:check_time])
              {result: 1, content: inventory}
            else
              {result: 0, content: '更新数据失败'}
            end
          end
        end
      end

      desc "get random check total"
      get :random_total do
        {result: 1, content: Inventory.random_check.count}
      end

      desc "download random check data"
      params do
        optional :page, type: Integer
        optional :per_page, type: Integer
      end
      get :down_random_check_data do
        if params[:page].present? && params[:per_page].present?
          inventories = Inventory.random_check.offset(params[:page]*params[:per_page]).limit(params[:per_page])
        else
          inventories = Inventory.random_check
        end
        if inventories.present?
          present :result,1
          present :content, inventories
        else
          present :result, 0
          present :content, "暂无数据"
        end
      end


      desc "upload random_check_data"
      params do
        requires :id, type: Integer
        requires :random_check_qty, type: String
        requires :random_check_user, type: String
        requires :random_check_time, type: String
      end
      post :upload_random_check_data do
        if params[:id].blank?
          {result: 0, content: '数据不完整'}
        else
          inventory = Inventory.find(params[:id])
          if inventory.present?
            if inventory.update!(random_check_qty: params[:random_check_qty],
                                 random_check_user: params[:random_check_user],
                                 random_check_time: params[:random_check_time])
              {result: 1, content: inventory}
            else
              {result: 0, content: '更新数据失败'}
            end
          else
            {result: 0, content: '查无此数据'}

          end
        end
      end

    end

    namespace :inventory_file do
      desc "downlaod inventory file"
      params do
        requires :type, type: Integer
      end
      get :download_inventory_file do
        unless [FileUploadType::OVERALL, FileUploadType::SPOTCHECK].include?(params[:type])
          return {result: 0, content: "盘点类型#{params[:type]}不正确"}
        end

        if file=Inventory.generate_file(params[:type])
          present :result, 1
          present :content, request.base_url + file.path.url
        else
          {result: 0, content: '当前无数据'}
        end
      end

      desc "upload inventory file"
      params do
        requires :user_id, type: String
        requires :type, type: Integer
        requires :data, type: String
      end
      post :upload_inventory_file do
        unless user=User.find_by_nr(params[:user_id])
          return {result: 0, content: "员工号#{params[:user_id]}不存在"}
        end

        unless [FileUploadType::OVERALL, FileUploadType::SPOTCHECK].include?(params[:type])
          return {result: 0, content: "盘点类型#{params[:type]}不正确"}
        end

        if params[:data].length<1
          return {result: 0, content: "数据为空"}
        end

        if FileTaskService.create_file_task params, user
          {result: 1, content: '数据上传成功'}
        else
          {result: 0, content: '数据上传失败'}
        end
      end

    end
  end
end
