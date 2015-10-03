class InventoriesController < ApplicationController
  before_action :set_inventory, only: [:show, :edit, :update, :destroy]

  def import
    if request.post?
      msg = Message.new
      tmp_file_path = 'uploadfiles'
      
      begin
        file = params[:files][0]
        fd = FileData.new(data: file, oriName: file.original_filename, path: tmp_file_path, pathName: "#{Time.now.strftime('%Y%m%d%H%M%S%L')}~#{file.original_filename}")
        fd.save
        msg = Excel::ExcelService.import(fd)
      rescue => e
        msg.content = e.message
      end
      render json: msg
    end
  end

  # GET /inventories
  # GET /inventories.json
  def index
    @inventories = Inventory
    
    if params[:search]
      puts "-----testing "
      # @inventories = @inventories.search(params[:search])
      @department = params[:department]
      @position_begin = params[:position_begin]
      @position_end = params[:position_end]
      @part = params[:part]
      @ios_created_id = params[:ios_created_id] 
      @is_random_check = params[:is_random_check] 
      @inventories = Inventory.search_by_condition(@department, @position_begin, @position_end, @part, @ios_created_id, @is_random_check)
   
      respond_to do |format|
        format.xlsx do
          send_data(entry_with_xlsx(@inventories), :type=> "application/vnd.openxmlformates-officedocument.spreadsheetml.sheet",
              :filename => "Inventory_#{DateTime.now.strftime("%Y%m%d%H%M%S")}.xlsx")
        end
        format.html do
          @inventories = @inventories.paginate(page: params[:page])
            # redirect_to inventories_url
        end
      end
    else
      @inventories = @inventories.paginate(page: params[:page])
    end
  end
  
  # def search
#     @inventories = Inventory
#
#     # @inventories = @inventories.where("department=? ", params[:department]) if params[:department].present?
# #     if params[:position_begin].present? && params[:position_end].present?
# #       @inventories = @inventories.where(" position between ? and ?", params[:position_begin], params[:position_end])
# #     end
#
#     @department = params[:department]
#     @position_begin = params[:position_begin]
#     @position_end = params[:position_end]
#     @part = params[:part]
#     @ios_created_id = params[:ios_created_id]
#     @is_random_check = params[:is_random_check]
#
#
#     @inventories = Inventory.search_by_condition(@department, @position_begin, @position_end, @part, @ios_created_id, @is_random_check)
#     # @inventories = @inventories.
#     respond_to do |format|
#       format.xlxl do
#         send_data(entry_with_xlsx(@inventories), :type=> "application/vnd.openxmlformates-officedocument.spreadsheetml.sheet",
#             :filename => "Inventory_#{DateTime.now.strftime("%Y%m%d%H%M%S")}.xlsx")
#       end
#       format.html
#     end
#   end
  
  def entry_with_xlsx inventories
    p = Axlsx::Package.new
    wb = p.workbook
    wb.add_worksheet(:name => "sheet1") do |sheet|
      sheet.add_row ["序号", "部门", "库位", "零件号", "零件类型", "全盘数量", "全盘员工", "全盘时间", "抽盘数量", "抽盘员工", "抽盘时间", "是否抽盘", "iOS新建id"]
      puts "--testing #{inventories.count}"
      inventories.each_with_index { |inventory, index|
        sheet.add_row [
          index+1,
          inventory.department,
          inventory.position,
          inventory.part,
          inventory.part_type,
          inventory.check_qty,
          inventory.check_user,
          inventory.check_time,
          inventory.random_check_qty,
          inventory.random_check_user,
          inventory.random_check_time,
          inventory.is_random_check,
          inventory.ios_created_id        
          ], :types => [:string]
      }
    end
    p.to_stream.read
  end

  # GET /inventories/1
  # GET /inventories/1.json
  def show
  end

  # GET /inventories/new
  def new
    @inventory = Inventory.new
  end

  # GET /inventories/1/edit
  def edit
  end

  # POST /inventories
  # POST /inventories.json
  def create
    @inventory = Inventory.new(inventory_params)

    respond_to do |format|
      if @inventory.save
        format.html { redirect_to @inventory, notice: 'Inventory was successfully created.' }
        format.json { render :show, status: :created, location: @inventory }
      else
        format.html { render :new }
        format.json { render json: @inventory.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /inventories/1
  # PATCH/PUT /inventories/1.json
  def update
    respond_to do |format|
      if @inventory.update(inventory_params)
        format.html { redirect_to @inventory, notice: 'Inventory was successfully updated.' }
        format.json { render :show, status: :ok, location: @inventory }
      else
        format.html { render :edit }
        format.json { render json: @inventory.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /inventories/1
  # DELETE /inventories/1.json
  def destroy
    @inventory.destroy
    respond_to do |format|
      format.html { redirect_to inventories_url, notice: 'Inventory was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_inventory
      @inventory = Inventory.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def inventory_params
      params.require(:inventory).permit(:department, :position, :part, :part_type, :check_qty, :check_user, :check_time, :random_check_qty, :random_check_user, :random_check_time, :is_random_check, :ios_created_id, :position_begin, :position_end)
    end
end
