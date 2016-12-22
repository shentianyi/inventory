class InventoryFilesController < ApplicationController
  before_action :set_inventory_file, only: [:show, :edit, :update, :destroy]

  # GET /inventory_files
  # GET /inventory_files.json
  def index
    @inventory_files = InventoryFile.all
  end

  # GET /inventory_files/1
  # GET /inventory_files/1.json
  def show
  end

  # GET /inventory_files/new
  def new
    @inventory_file = InventoryFile.new
  end

  # GET /inventory_files/1/edit
  def edit
  end

  # POST /inventory_files
  # POST /inventory_files.json
  def create
    @inventory_file = InventoryFile.new(inventory_file_params)

    respond_to do |format|
      if @inventory_file.save
        format.html { redirect_to @inventory_file, notice: 'Inventory file was successfully created.' }
        format.json { render :show, status: :created, location: @inventory_file }
      else
        format.html { render :new }
        format.json { render json: @inventory_file.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /inventory_files/1
  # PATCH/PUT /inventory_files/1.json
  def update
    respond_to do |format|
      if @inventory_file.update(inventory_file_params)
        format.html { redirect_to @inventory_file, notice: 'Inventory file was successfully updated.' }
        format.json { render :show, status: :ok, location: @inventory_file }
      else
        format.html { render :edit }
        format.json { render json: @inventory_file.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /inventory_files/1
  # DELETE /inventory_files/1.json
  def destroy
    @inventory_file.destroy
    respond_to do |format|
      format.html { redirect_to inventory_files_url, notice: 'Inventory file was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_inventory_file
      @inventory_file = InventoryFile.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def inventory_file_params
      params.require(:inventory_file).permit(:name, :path, :size)
    end
end
