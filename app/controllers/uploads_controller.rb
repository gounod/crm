# encoding: utf-8

class UploadsController < ApplicationController
  # def new
  #   @upload = Upload.new
  # end

  def create
    @upload = Upload.create(upload_params)
    if @upload.save
      # send success header
      render json: { message: "success", fileID: @upload.id }, :status => 200
    else
      #  you need to send an error header, otherwise Dropzone
      #  will not interpret the response as an error:
      render json: { error: @upload.errors.full_messages.join(',')}, :status => 400
    end
  end

  def destroy
    @upload = Upload.find(params[:id])
    respond_to do |format|
      if @upload.destroy
        format.json { render :json => { message: "File deleted from server" } }
        format.html { redirect_to gallery_path() }
      else
        format.html { redirect_to gallery_path() }
        format.json { render :json => { message: @upload.errors.full_messages.join(',') } }
      end
    end
  end

  private
  def upload_params
    params.require(:upload).permit([:image, :discussion_id])
  end
end
