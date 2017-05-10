class DevicesController < ApplicationController

  def index
    if params[:category_id].present?
      @devices = Device.get_devices_by_category(category_id)
        .page(params[:page]).per Settings.view.device.per_page
    else
      @devices = Device.get_all_devices
        .page(params[:page]).per Settings.view.device.per_page
    end
    return if @devices.present?
    flash[:errors] = t "device.device_not_found"
    redirect_to root_path
  end

  def show
    @device = Device.find_by id: params[:id]
    return if @device.present?
    flash[:errors] = t "device.device_not_found"
    redirect_to devices_path
  end

end
