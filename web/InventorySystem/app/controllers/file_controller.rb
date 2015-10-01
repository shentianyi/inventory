class FileController < ApplicationController
  def download
    path = File.join('uploadfiles', params[:folder], params[:file])
    send_file path, :filename => params["file"]
  end
end
