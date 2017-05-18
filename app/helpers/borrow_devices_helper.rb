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
    when BorrowDevice.borrow_statuses[:leader]
      t "borrow_device.leader"
    when BorrowDevice.borrow_statuses[:borrowed]
      t "borrow_device.borrowed"
    else
      t "borrow_device.return"
    end
  end
end
