class Admin::DevicesController < Admin::BaseController
  load_and_authorize_resource except: :create
  before_action :load_device, only: [:edit, :update, :destroy]

  def index
    if verify_admin current_user
      if params[:fitter].present?
        @devices = Device.get_devices_by_workspace params[:fitter]
          .page(params[:page]).per Settings.view.device.per_page
      else
        @devices = Device.all
          .page(params[:page]).per Settings.view.device.per_page
      end
    else
      @devices = Device.get_devices_by_workspace(current_user
        .group.workspace_id)
        .page(params[:page]).per Settings.view.device.per_page
    end
    if @devices.present?
      respond_to do |format|
        format.html
        format.js
        format.xls {send_data @devices.to_csv}
      end
    else
      flash[:warning] = t "device.device_not_found"
      redirect_to root_path
    end
  end

  def new
    @device = Device.new
    @base_support = Supports::BaseSupport.new
  end

  def create
    authorize! :create, @device
    if params[:import]
      if params[:import_file].present?
        import params[:import_file]
      else
        flash[:errors] = t "device.file_not_found"
        redirect_to new_admin_device_path
      end
    else
      @device = Device.new device_params
      if @device.save
        flash[:success] = t "device.created"
        redirect_to admin_devices_path
      else
        render :new
      end
    end
  end

  def edit
    @base_support = Supports::BaseSupport.new
  end

  def update
    if @device.update_attributes device_params
      flash[:success] = t "device.updated"
    else
      flash[:errors] = t "device.update_failed"
    end
    redirect_to admin_devices_path
  end

  def destroy
    if @device.destroy
      flash[:success] = t "device.deleted"
    else
      flash[:errors] = t "device.delete_failed"
    end
    redirect_to admin_devices_path
  end


  private
  def device_params
    params.require(:device).permit :name, :thumnail, :informations, :status,
      :category_id, :workspace_id
  end

  def load_device
    @device = Device.find_by id: params[:id]
    unless @device.present?
      flash[:warning] = t "device.device_not_found"
      redirect_to admin_devices_path
    end
  end

  def import file
    arr_failed = Device.import file
    if arr_failed.nil?
      flash[:errors] = t "device.import_header_failed"
      redirect_to new_admin_device_path
    elsif arr_failed.blank?
      flash[:success] = t "device.imported"
      redirect_to admin_devices_path
    else
      flash[:errors] = t("device.imported_failed", id: arr_failed)
      redirect_to admin_devices_path
    end
  end
end
