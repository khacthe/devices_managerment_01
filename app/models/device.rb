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

  private
  def set_defaults
    self.borrowed ||= false
  end

end
