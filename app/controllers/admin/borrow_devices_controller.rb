class Admin::BorrowDevicesController < Admin::BaseController
  include BorrowDevicesHelper
  load_and_authorize_resource except: :create
  before_action :load_borrow_device, only: [:show, :edit]

  def new
    @borrow_device = BorrowDevice.new
    devices = get_list_devices
    return if devices.present?
    flash[:errors] = t "borrow_device.device_not_found"
    redirect_to admin_borrow_devices_path
  end

  def index
    case current_user.position
    when User.user_positions[:leader]
      @borrowed_devices = BorrowDevice
        .list_borrowed_in_group(current_user.group_id)
        .page(params[:page]).per Settings.view.borrow_device.per_page
    when User.user_positions[:bo]
      @borrowed_devices = BorrowDevice
        .list_borrowed_in_workspace(current_user.group.workspace_id)
        .page(params[:page]).per Settings.view.borrow_device.per_page
    when User.user_positions[:admin]
      @borrowed_devices = BorrowDevice.get_all
        .page(params[:page]).per Settings.view.borrow_device.per_page
    end
    return if @borrowed_devices.present?
    flash[:errors] = t "borrow_device.device_not_found"
    redirect_to root_path
  end

  def create
    authorize! :create, @borrow_device
    @borrow_device = BorrowDevice.new borrow_device_params
    devices = get_list_devices
    if devices.present?
      flag = false
      if check_date_borrow
        flag = create_new_borrow @borrow_device, devices
        if flag
          session.delete(:item)
          flash[:success] = t "borrow_device.congratulations"
          redirect_to admin_borrow_devices_path
        else
          flash[:errors] = t "borrow_device.create_failed"
          redirect_to new_admin_borrow_device_path
        end
      else
        get_list_devices
        render :new
      end
    else
      flash[:errors] = t "borrow_device.device_not_found"
      redirect_to devices_path
    end
  end

  def show
  end

  def edit
  end

  def update
    @borrow_device = BorrowDevice.find_by id: params[:id]
    if @borrow_device.present?
      flag = false
      if params[:borrow_device][:status].present? &&
        @borrow_device.status != BorrowDevice.borrow_statuses[:reject]
        @borrow_device.status = params[:borrow_device][:status].to_i
        flag = update_borrow @borrow_device
        if flag
          flash[:success] = t "borrow_device.updated"
        else
          flash[:errors] = t "borrow_device.update_failed"
        end
      else
        flash[:errors] = t "borrow_device.cant_update"
      end
    else
      flash[:errors] = t "borrow_device.borrow_not_found"
    end
    redirect_to admin_borrow_devices_path
  end

  private
  def borrow_device_params
    params.require(:borrow_device).permit :user_id, :borrow_date_from,
      :borrow_date_to, :status, :borrow_type
  end

  def load_borrow_device
    @borrowed_device = BorrowDevice.find_by id: params[:id]
    if @borrowed_device.present?
      @borrowed_items = @borrowed_device.borrow_items
      return if @borrowed_items.present?
      flash[:errors] = t "borrow_device.device_not_found"
    else
      flash[:errors] = t "borrow_device.borrow_not_found"
    end
    redirect_to admin_borrow_devices_path
  end

end
