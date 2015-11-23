class PartsController < ApplicationController
  before_action :set_part, only: [:show, :edit, :update, :destroy]

  # GET /parts
  # GET /parts.json
  def index
    if params[:search]
      @parts= params[:q].blank? ? Part.all : Part.search_for(params[:q])

      respond_to do |format|
        format.xlsx do
          send_data(entry_with_xlsx(@parts), :type => "application/vnd.openxmlformates-officedocument.spreadsheetml.sheet",
                    :filename => "Part_#{DateTime.now.strftime("%Y%m%d%H%M%S")}.xlsx")
        end
        format.html do
          @parts = @parts.paginate(page: params[:page])
        end
      end
    else
      @parts = Part.paginate(page: params[:page])
    end
  end

  # GET /parts/1
  # GET /parts/1.json
  def show
  end

  # GET /parts/new
  def new
    @part = Part.new
  end

  # GET /parts/1/edit
  def edit
  end

  # POST /parts
  # POST /parts.json
  def create
    @part = Part.new(part_params)

    respond_to do |format|
      if @part.save
        format.html { redirect_to @part, notice: 'Part was successfully created.' }
        format.json { render :show, status: :created, location: @part }
      else
        format.html { render :new }
        format.json { render json: @part.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /parts/1
  # PATCH/PUT /parts/1.json
  def update
    respond_to do |format|
      if @part.update(part_params)
        format.html { redirect_to @part, notice: 'Part was successfully updated.' }
        format.json { render :show, status: :ok, location: @part }
      else
        format.html { render :edit }
        format.json { render json: @part.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /parts/1
  # DELETE /parts/1.json
  def destroy
    @part.destroy
    respond_to do |format|
      format.html { redirect_to parts_url, notice: 'Part was successfully destroyed.' }
      format.json { head :no_content }
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
        msg = Excel::PartService.import(fd)
      rescue => e
        msg.content = e.message
      end
      render json: msg
    end
  end

  def entry_with_xlsx parts
    p = Axlsx::Package.new
    p.use_shared_strings = true
    wb = p.workbook
    wb.add_worksheet(:name => "sheet1") do |sheet|
      sheet.add_row ["零件号", "类型", "单位"]
      #puts "--testing #{inventories.count}"
      parts.each { |part|
        sheet.add_row [
                          part.nr,
                          part.type,
                          part.unit
                      ], :types => [:string]
      }
    end
    p.to_stream.read
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_part
    @part = Part.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def part_params
    params.require(:part).permit(:nr, :type, :unit)
  end
end
