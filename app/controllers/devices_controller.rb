class DevicesController < ApplicationController

  def index
    if params[:category_id].present?
      device_all = Device.get_devices_by_category params[:category_id]
    else
      device_all = Device.get_devices_by_workspace(current_user
        .group.workspace_id)
    end
    @search = device_all.search params[:q]
    @devices = @search.result
      .page(params[:page]).per Settings.view.device.per_page
    @base_support = Supports::BaseSupport.new
    return if @devices.present?
    flash[:errors] = t "device.device_not_found"
    redirect_to devices_path
  end

  def show
    @device = Device.find_by id: params[:id]
    return if @devices.present?
    flash[:errors] = t "device.device_not_found"
    redirect_to devices_path
  end

end
