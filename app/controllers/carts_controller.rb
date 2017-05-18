class CartsController < ApplicationController

  def create
    init_session
    device_id = params[:device_id].to_i
    add_device_into_item device_id
  end

  def destroy
    device_id = params[:device_id].to_i
    return if delete_device_in_item device_id
    flash[:errors] = t "borrow_device.delete_failed"
    redirect_to devices_path
  end
end
