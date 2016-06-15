class FileTasksController < ApplicationController
  before_action :set_file_task, only: [:show, :edit, :update, :destroy]

  # GET /file_tasks
  # GET /file_tasks.json
  def index
    @http_host=request.env["HTTP_HOST"]
    @file_tasks = FileTask
    @file_tasks = @file_tasks.search(params[:search]) if params[:search]
    @file_tasks = @file_tasks.order(status: :desc).paginate(page: params[:page])
  end

  # GET /file_tasks/1
  # GET /file_tasks/1.json
  def show
  end

  # GET /file_tasks/new
  def new
    @file_task = FileTask.new
  end

  # GET /file_tasks/1/edit
  def edit
  end

  # POST /file_tasks
  # POST /file_tasks.json
  def create
    @file_task = FileTask.new(file_task_params)

    respond_to do |format|
      if @file_task.save
        format.html { redirect_to @file_task, notice: 'File task was successfully created.' }
        format.json { render :show, status: :created, location: @file_task }
      else
        format.html { render :new }
        format.json { render json: @file_task.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /file_tasks/1
  # PATCH/PUT /file_tasks/1.json
  def update
    respond_to do |format|
      if @file_task.update(file_task_params)
        format.html { redirect_to @file_task, notice: 'File task was successfully updated.' }
        format.json { render :show, status: :ok, location: @file_task }
      else
        format.html { render :edit }
        format.json { render json: @file_task.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /file_tasks/1
  # DELETE /file_tasks/1.json
  def destroy
    @file_task.destroy
    respond_to do |format|
      format.html { redirect_to file_tasks_url, notice: 'File task was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_file_task
    @file_task = FileTask.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def file_task_params
    params.require(:file_task).permit(:user_id, :data_file_id, :err_file_id, :status, :remark, :type)
  end
end
