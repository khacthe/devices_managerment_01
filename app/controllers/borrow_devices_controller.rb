class BorrowDevicesController < ApplicationController

  def index
    @borrowed_devices = BorrowDevice.find_by_user_id(current_user.id)
      .page(params[:page]).per Settings.view.borrow_device.per_page
    return if @borrowed_devices.present?
    flash[:errors] = t "borrow_device.borrow_not_found"
    redirect_to root_path
  end

  def new
    @borrow_device = BorrowDevice.new
    devices = get_list_devices
    return if devices.present?
    flash[:errors] = t "borrow_device.device_not_found"
    redirect_to devices_path
  end

  def create
    borrow_device = BorrowDevice.new borrow_device_params
    devices = get_list_devices
    flag = false
    if devices.present?
      if check_date_borrow == true
        Device.transaction do
          BorrowItem.transaction do
            BorrowDevice.transaction do
              raise ActiveRecord::Rollback unless borrow_device.save
              devices.each do |device|
                if !device.borrowed
                  borrowed_item = BorrowItem.new_borrow_item(device.id,
                    borrow_device.id)
                  raise ActiveRecord::Rollback unless borrowed_item.save
                else
                  delete_device_in_item device.id
                  raise ActiveRecord::Rollback
                end
              end
              devices.each do |device|
                raise ActiveRecord::Rollback unless device
                  .update_attributes(borrowed: true)
              end
              flag = true
            end
          end
        end
        if flag
          session.delete(:item)
          flash[:success] = t "borrow_device.congratulations"
          redirect_to borrow_devices_path
        else
          flash[:errors] = t "borrow_device.create_failed"
          redirect_to new_borrow_device_path
        end
      else
        get_list_devices
        flash[:errors] = t "borrow_device.date_invalid"
        redirect_to new_borrow_device_path
      end
    else
      flash[:errors] = t "borrow_device.device_not_found"
      redirect_to devices_path
    end
  end

  def edit
    @borrow_device = BorrowDevice.find_by id: params[:id]
    return if @borrow_device.present?
    flash[:errors] = t "borrow_device.device_not_found"
    redirect_to borrow_devices_path
  end

  def show
    @borrowed_device = BorrowDevice.find_by id: params[:id]
    if @borrowed_device.present?
      @borrowed_items = BorrowItem.get_list_item_by_borrow_id params[:id]
      return if @borrowed_items.present?
      flash[:errors] = t "borrow_device.item_not_found"
      redirect_to borrow_devices_path
    else
      flash[:errors] = t "borrow_device.borrow_not_found"
      borrow_devices_path
    end
  end

  def update
    borrow_device = BorrowDevice.find_by id: params[:id]
    if borrow_device.present?
      flag = false
      borrow_device.status = BorrowDevice.borrow_statuses[:reject]
      BorrowDevice.transaction do
        Device.transaction do
          borrow_device.borrow_items.each do |item|
            device = item.device
            device.borrowed = false
            raise ActiveRecord::Rollback unless device.save
          end
          raise ActiveRecord::Rollback unless borrow_device.save
          flag = true
        end
      end
      if flag
        flash[:success] = t "borrow_device.updated"
      else
        flash[:success] = t "borrow_device.update_failed"
      end
    else
      flash[:errors] = t "borrow_device.borrow_not_found"
    end
    redirect_to borrow_devices_path
  end

  private

  def check_date_borrow
    date_from = params[:borrow_device][:borrow_date_from]
    date_to = params[:borrow_device][:borrow_date_to]
    if date_from.present? && date_to.present?
      return Date.parse(date_from) < Date.parse(date_to)
    else
      false
    end
  end

  def borrow_device_params
    params.require(:borrow_device).permit :user_id, :borrow_date_from,
      :borrow_date_to, :status
  end

end
