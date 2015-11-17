class FilesController < ApplicationController
  def download
    path = File.join('uploadfiles', params[:folder], params[:file])
    send_file path, :filename => params["file"]
  end
  
  def show
    send_file Base64.urlsafe_decode64(params[:id])
  end
end
