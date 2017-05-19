class Group < ApplicationRecord

  has_many :users, dependent: :destroy

  belongs_to :workspace

  validates :name, presence: true, uniqueness: true

  scope :list_group_by_workspace, -> workspace_id do
    Group.where(workspace_id: workspace_id).map(&:id)
  end

end
