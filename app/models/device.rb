class Device < ApplicationRecord

  after_initialize :set_defaults, unless: :persisted?

  has_many :borrow_items, dependent: :destroy

  belongs_to :category
  belongs_to :workspace

  validates :name, presence: true
  validates :informations, presence: true

  scope :get_all_devices, -> do
    Device.all.order(borrowed: :asc)
  end

  scope :get_devices_by_category, -> category_id do
    where(category_id: category_id)
  end

  scope :get_devices_by_ids, -> ids do
    where(id: ids)
  end

  scope :get_all, -> workspace_id do
    where(workspace_id: workspace_id)
  end

  scope :get_date_to, -> device_id do
    waiting = BorrowDevice.borrow_statuses[:waiting]
    leader_accept = BorrowDevice.borrow_statuses[:leader]
    borrowed = BorrowDevice.borrow_statuses[:borrowed]
    Device.joins(borrow_items: :borrow_device)
      .select(:borrow_date_to)
      .where(devices: {id: device_id},
      borrow_devices: {status: [waiting, leader_accept, borrowed]})
      .map(&:borrow_date_to).first
  end

  private
  def set_defaults
    self.borrowed ||= false
  end

end
