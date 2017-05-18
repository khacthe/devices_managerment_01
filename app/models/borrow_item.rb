class BorrowItem < ApplicationRecord

  belongs_to :borrow_device
  belongs_to :device

  scope :get_list_item_by_borrow_id, -> borrow_id do
    where(borrow_device_id: borrow_id)
  end

  class << self
    def new_borrow_item device_id, borrow_device_id
      BorrowItem.new device_id: device_id, borrow_device_id: borrow_device_id
    end
  end

end
