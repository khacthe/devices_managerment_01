class User < ApplicationRecord

  after_initialize :set_defaults, unless: :persisted?

  enum user_position: [:member, :leader, :bo, :admin]

  has_many :notifications, dependent: :destroy
  has_many :messages, dependent: :destroy
  has_many :borrow_devices, dependent: :destroy

  belongs_to :group

  devise :database_authenticatable, :rememberable, :validatable

  validates :position, presence: true,
    inclusion: {in: User.user_positions.values}

  scope :get_manager, -> position {where position: position}

  private
  def set_defaults
    self.position ||= User.user_positions[:member]
  end

end
