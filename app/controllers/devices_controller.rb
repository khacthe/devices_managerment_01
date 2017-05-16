class DevicesController < ApplicationController

  def index
    if params[:category_id].present?
      load_devices_by_category params[:category_id]
    else
      @search = Device.search(params[:q])
      @devices = @search.result
        .page(params[:page]).per Settings.view.device.per_page
      return if @devices.present?
      flash[:errors] = t "device.device_not_found"
      redirect_to devices_path
    end
  end

  def show
    @device = Device.find_by id: params[:id]
    return if @device.present?
    flash[:errors] = t "device.device_not_found"
    redirect_to devices_path
  end

end
