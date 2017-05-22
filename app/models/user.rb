class User < ApplicationRecord
  rolify

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

  scope :list_user_id_by_group, -> group_id do
    User.where(group_id: group_id).map(&:id)
  end

  scope :list_user_id_by_workspace, -> workspace_id do
    User.where(group_id: Group.list_group_by_workspace(workspace_id)).map(&:id)
  end

  private
  def set_defaults
    self.position ||= User.user_positions[:member]
  end

end
