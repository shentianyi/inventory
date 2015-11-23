class InventoriesController < ApplicationController
  before_action :set_inventory, only: [:show, :edit, :update, :destroy]

  def random
    Inventory.create_random_data
    respond_to do |format|
      format.js
    end

  end

  def import
    if request.post?
      msg = Message.new
      tmp_file_path = 'uploadfiles'

      begin
        file = params[:files][0]
        fd = FileData.new(data: file, oriName: file.original_filename, path: tmp_file_path, pathName: "#{Time.now.strftime('%Y%m%d%H%M%S%L')}~#{file.original_filename}")
        fd.save
        msg = Excel::InventoryService.import(fd)
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
      @check_user=params[:check_user]
      @position_begin = params[:position_begin]
      @position_end = params[:position_end]
      @part_nr = params[:part_nr]
      @ios_created_id = params[:ios_created_id]
      @is_random_check = params[:is_random_check]
      @inventories = Inventory.search_by_condition(@department, @position_begin, @position_end, @part_nr, @ios_created_id, @is_random_check, {check_user: @check_user,
                                                                                                                                              random_check_user: params[:random_check_user]})

      respond_to do |format|
        format.xlsx do
          send_data(entry_with_xlsx(@inventories), :type => "application/vnd.openxmlformates-officedocument.spreadsheetml.sheet",
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

  def entry_with_xlsx inventories
    p = Axlsx::Package.new
    p.use_shared_strings = true
    wb = p.workbook
    wb.add_worksheet(:name => "sheet1") do |sheet|
      sheet.add_row ["序号", "部门", "库位", "零件号", "零件类型", "零件单位", "全盘数量", "全盘员工", "全盘时间", "抽盘数量", "抽盘员工", "抽盘时间", "是否抽盘", "iOS新建id"]
      #puts "--testing #{inventories.count}"
      inventories.each_with_index { |inventory, index|
        sheet.add_row [
                          inventory.sn,
                          "\t#{inventory.department}",
                          "\t#{inventory.position}",
                          "\t#{inventory.part_nr}",
                          "\t#{inventory.part_type}",
                          "\t#{inventory.part_unit}",
                          inventory.check_qty,
                          "\t#{inventory.check_user}",
                          inventory.check_time_display,
                          inventory.random_check_qty,
                          "\t#{inventory.random_check_user}",
                          inventory.random_check_time_display,
                          inventory.is_random_check_display,
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
    params.require(:inventory).permit(:department, :position, :part_nr,:part_unit,:part_type, :check_qty, :check_user, :random_check_qty, :random_check_user, :is_random_check, :ios_created_id, :position_begin, :position_end)
  end
end
