class BorrowItem < ApplicationRecord

  belongs_to :borrow_device
  belongs_to :device

end
