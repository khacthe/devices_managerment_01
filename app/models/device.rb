class Device < ApplicationRecord

  after_initialize :set_defaults, unless: :persisted?

  has_many :borrow_items, dependent: :destroy

  belongs_to :category
  belongs_to :workspace

  validates :name, presence: true
  validates :informations, presence: true

  private
  def set_defaults
    self.borrowed ||= false
  end

end
