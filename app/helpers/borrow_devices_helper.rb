module BorrowDevicesHelper
  def check_over_time borrow_device
    now = DateTime.now.to_date
    now > borrow_device.borrow_date_to.to_date ? true : false
  end

  def get_borrow_status status
    case status
    when BorrowDevice.borrow_statuses[:reject]
      t "borrow_device.reject_status"
    when BorrowDevice.borrow_statuses[:waiting]
      t "borrow_device.member"
    when BorrowDevice.borrow_statuses[:leader_accept]
      t "borrow_device.leader"
    when BorrowDevice.borrow_statuses[:borrowed]
      t "borrow_device.borrowed"
    else
      t "borrow_device.return"
    end
  end

  def get_borrow_status_value status
    case current_user.position
    when User.user_positions[:leader]
      BorrowDevice.borrow_statuses[:leader_accept]
    when User.user_positions[:bo]
      if status == BorrowDevice.borrow_statuses[:leader_accept]
        BorrowDevice.borrow_statuses[:borrowed]
      elsif status == BorrowDevice.borrow_statuses[:borrowed]
        BorrowDevice.borrow_statuses[:return]
      end
    end
  end

  def get_lable_borrow_update status
    case status
    when BorrowDevice.borrow_statuses[:member]
      t "borrow_device.btn_accept"
    when BorrowDevice.borrow_statuses[:leader_accept]
      t "borrow_device.btn_borrow"
    when BorrowDevice.borrow_statuses[:borrowed]
      t "borrow_device.btn_return"
    end
  end

  def update_borrow borrow_device
    result = true
    BorrowDevice.transaction do
      if borrow_device.save
        if borrow_device.status == BorrowDevice.borrow_statuses[:return] ||
          borrow_device.status == BorrowDevice.borrow_statuses[:reject]
          result = set_device_return borrow_device.borrow_items
          raise ActiveRecord::Rollback unless result
        end
      end
    end
    result
  end

  def set_device_return borrow_items
    flag = false
    Device.transaction do
      borrow_items.each do |item|
        device = item.device
        device.borrowed = false
        raise ActiveRecord::Rollback unless device.save
      end
      flag = true
    end
    flag
  end

  def check_date_borrow
    date_from = params[:borrow_device][:borrow_date_from]
    date_to = params[:borrow_device][:borrow_date_to]
    if date_from.present? && date_to.present?
      return Date.parse(date_from) < Date.parse(date_to)
    else
      false
    end
  end

  def create_new_borrow borrow_device, devices
    flag = false
    Device.transaction do
      BorrowItem.transaction do
        BorrowDevice.transaction do
          raise ActiveRecord::Rollback unless borrow_device.save
          devices.each do |device|
            if !device.borrowed
              borrow_item = BorrowItem.new_borrow_item(device.id,
                borrow_device.id)
              raise ActiveRecord::Rollback unless borrow_item.save
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
    flag
  end

end
